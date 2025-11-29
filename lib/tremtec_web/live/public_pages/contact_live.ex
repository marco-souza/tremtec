defmodule TremtecWeb.PublicPages.ContactLive do
  use TremtecWeb, :live_view

  require Logger
  alias Ecto.Changeset
  alias Tremtec.Messages

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, gettext("Contact"))
     |> assign(:submitted?, false)
     |> assign(:form, empty_form())}
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

            <div class="sr-only" aria-hidden="true">
              <label for="nickname">{gettext("Nickname")}</label>
              <input
                id="nickname"
                name="contact[nickname]"
                type="text"
                tabindex="-1"
                autocomplete="off"
              />
            </div>

            <div class="pt-2">
              <.button type="submit" phx-disable-with={gettext("Sending...")}>
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
    form =
      params
      |> changeset()
      |> Map.put(:action, :validate)
      |> to_form(as: :contact)

    {:noreply, assign(socket, form: form, submitted?: false)}
  end

  @impl true
  def handle_event("save", %{"contact" => params}, socket) do
    case Changeset.apply_action(changeset(params), :insert) do
      {:ok, data} ->
        _ = Messages.create_contact_message(data)

        {:noreply,
         socket
         |> put_flash(:info, gettext("Thanks! Your message has been sent."))
         |> assign(:submitted?, true)
         |> assign(:form, empty_form())}

      {:error, %Changeset{} = cs} ->
        {:noreply, assign(socket, form: to_form(cs, as: :contact), submitted?: false)}
    end
  end

  defp empty_form do
    %{}
    |> changeset()
    |> to_form(as: :contact)
  end

  defp changeset(params) when is_map(params) do
    types = %{name: :string, email: :string, message: :string, nickname: :string}

    {%{}, types}
    |> Changeset.cast(params, Map.keys(types))
    |> Changeset.validate_required([:name, :email, :message])
    |> Changeset.validate_format(:email, ~r/^\S+@\S+\.[\w\.]+$/)
    |> Changeset.validate_length(:message, min: 10)
    # Simple honeypot: if filled, add an error and prevent submit
    |> maybe_flag_spam()
  end

  defp changeset(_), do: changeset(%{})

  defp maybe_flag_spam(%Changeset{} = cs) do
    case Ecto.Changeset.get_change(cs, :nickname) do
      nil -> cs
      "" -> cs
      _ -> Changeset.add_error(cs, :base, gettext("Spam detected"))
    end
  end
end
