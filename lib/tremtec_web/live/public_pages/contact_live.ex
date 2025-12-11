defmodule TremtecWeb.PublicPages.ContactLive do
  use TremtecWeb, :live_view

  require Logger
  alias Ecto.Changeset
  alias Tremtec.Messages

  # Cloudflare Turnstile CAPTCHA Integration
  # - Widget: client-side verification
  # - Validation: server-side token verification via Siteverify API
  # - Token lifetime: 300 seconds (5 minutes)
  # - Tokens are single-use and expire automatically
  # - Request timeout is configurable via phoenix_turnstile config
  @turnstile_timeout Application.compile_env(:phoenix_turnstile, :request_timeout, 5000)

  @impl true
  def mount(_params, _session, socket) do
    form = empty_form()

    {:ok,
     socket
     |> assign(:page_title, gettext("Contact"))
     |> assign(:submitted?, false)
     |> assign(:captcha_valid?, false)
     |> assign(:form, form)
     |> assign(:form_valid?, form.source.valid?)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="max-w-2xl mx-auto px-4 py-10">
        <.header>
          {gettext("Contact")}
          <:subtitle>{gettext("We'd love to hear from you. Send us a message.")}</:subtitle>
        </.header>

        <div class="card bg-base-200/40 border border-base-300 shadow-sm rounded-xl p-6">
          <.form
            for={@form}
            id="contact-form"
            phx-change="validate"
            phx-submit="save"
            class="space-y-4"
          >
            <.input
              field={@form[:name]}
              type="text"
              label={gettext("Name")}
              placeholder={gettext("Your name")}
              required
            />

            <.input
              field={@form[:email]}
              type="email"
              label={gettext("Email")}
              placeholder={gettext("your@email.com")}
              autocomplete="email"
              inputmode="email"
              required
            />

            <.input
              field={@form[:message]}
              type="textarea"
              label={gettext("Message")}
              placeholder={gettext("How can we help?")}
              rows="6"
              minlength="10"
              required
            />
            
    <!-- Cloudflare Turnstile CAPTCHA widget -->
            <div class="flex justify-center my-4">
              <Turnstile.widget
                id="contact-captcha"
                theme="light"
                size="normal"
                events={[:success, :error, :expired]}
              />
            </div>

            <div class="pt-2">
              <.button
                type="submit"
                phx-disable-with={gettext("Sending...")}
                disabled={not (@form_valid? and @captcha_valid?)}
              >
                {gettext("Send message")}
              </.button>
            </div>
          </.form>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def handle_event("validate", %{"contact" => params}, socket) do
    changeset = params |> changeset() |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(form: to_form(changeset, as: :contact), submitted?: false)
     |> assign(form_valid?: changeset.valid?)}
  end

  # Handle CAPTCHA success event
  @impl true
  def handle_event("turnstile:success", _params, socket) do
    # Mark CAPTCHA as validated when user completes the challenge
    {:noreply, assign(socket, captcha_valid?: true)}
  end

  # Handle CAPTCHA error event
  @impl true
  def handle_event("turnstile:error", _params, socket) do
    # Mark as invalid if there's an error
    {:noreply, assign(socket, captcha_valid?: false)}
  end

  # Handle CAPTCHA expiration event
  @impl true
  def handle_event("turnstile:expired", _params, socket) do
    # Token expired, user needs to complete again
    {:noreply, assign(socket, captcha_valid?: false)}
  end

  @impl true
  def handle_event("save", %{"contact" => params} = full_params, socket) do
    # Extract Turnstile token
    captcha_token = full_params["cf-turnstile-response"]

    # Validate form fields first
    case Changeset.apply_action(changeset(params), :insert) do
      {:ok, data} ->
        # Form is valid, now validate CAPTCHA
        case validate_captcha(captcha_token, socket) do
          {:ok, captcha_response} ->
            # Log successful validation
            Logger.info("Captcha validation succeeded",
              extra: %{challenge_ts: captcha_response["challenge_ts"]}
            )

            # CAPTCHA and form are valid, save message
            _ = Messages.create_contact_message(data)

            new_form = empty_form()

            {:noreply,
             socket
             |> put_flash(:info, gettext("Thanks! Your message has been sent."))
             |> assign(:submitted?, true)
             |> assign(:captcha_valid?, false)
             |> assign(:form, new_form)
             |> assign(:form_valid?, new_form.source.valid?)}

          {:error, reason} ->
            # Log validation failure
            Logger.warning("Captcha validation failed", extra: %{reason: inspect(reason)})

            # Show error and reset widget
            cs = changeset(params)

            {:noreply,
             socket
             |> put_flash(
               :error,
               gettext("Verification failed. Please try again.")
             )
             |> assign(:submitted?, false)
             |> assign(:captcha_valid?, false)
             |> assign(:form, to_form(cs, as: :contact))
             |> assign(:form_valid?, cs.valid?)}
        end

      {:error, %Changeset{} = cs} ->
        {:noreply,
         socket
         |> assign(form: to_form(cs, as: :contact), submitted?: false)
         |> assign(:form_valid?, cs.valid?)}
    end
  end

  defp empty_form do
    %{}
    |> changeset()
    |> to_form(as: :contact)
  end

  defp changeset(params) when is_map(params) do
    types = %{name: :string, email: :string, message: :string}

    {%{}, types}
    |> Changeset.cast(params, Map.keys(types))
    |> Changeset.validate_required([:name, :email, :message])
    # Simple email format validation. Note: This pattern does not validate
    # all RFC 5322 compliant emails (e.g., rejects user+tag@example.com).
    # For MVP, this is acceptable. If needed, can upgrade to email_checker package.
    |> Changeset.validate_format(:email, ~r/^\S+@\S+\.[\w\.]+$/)
    |> Changeset.validate_length(:message, min: 10)
  end

  defp changeset(_), do: changeset(%{})

  # Cloudflare Turnstile CAPTCHA validation
  # Verifies token with Cloudflare Siteverify API
  defp validate_captcha(token, _socket) when is_binary(token) and byte_size(token) > 0 do
    secret_key = Application.fetch_env!(:phoenix_turnstile, :secret_key)

    verify_token_with_cloudflare(token, secret_key)
  end

  defp validate_captcha(nil, _socket) do
    {:error, :missing_token}
  end

  defp validate_captcha("", _socket) do
    {:error, :empty_token}
  end

  # Call Cloudflare Siteverify API
  defp verify_token_with_cloudflare(token, secret_key) do
    url = "https://challenges.cloudflare.com/turnstile/v0/siteverify"

    body = %{
      "secret" => secret_key,
      "response" => token
    }

    case Req.post(url, json: body, receive_timeout: @turnstile_timeout) do
      {:ok, %Req.Response{status: 200, body: response_body}} ->
        case response_body do
          %{"success" => true} = response ->
            Logger.debug("Turnstile verification successful",
              extra: %{
                challenge_ts: response["challenge_ts"],
                hostname: response["hostname"]
              }
            )

            {:ok, response}

          %{"success" => false} = response ->
            Logger.warning("Turnstile verification failed",
              extra: %{
                error_codes: response["error-codes"],
                challenge_ts: response["challenge_ts"]
              }
            )

            {:error, {:verification_failed, response["error-codes"]}}

          response ->
            Logger.warning("Unexpected Turnstile response", extra: %{response: response})
            {:error, :unexpected_response}
        end

      {:ok, %Req.Response{status: status}} ->
        Logger.error("Turnstile API error", extra: %{status: status})
        {:error, {:api_error, status}}

      {:error, reason} ->
        Logger.error("Turnstile request failed", extra: %{reason: inspect(reason)})
        {:error, {:request_failed, reason}}
    end
  end
end
