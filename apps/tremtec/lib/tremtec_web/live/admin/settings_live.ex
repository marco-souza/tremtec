defmodule TremtecWeb.Admin.Settings do
  use TremtecWeb, :live_view

  alias Tremtec.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      current_scope={@current_scope}
      is_admin={true}
      current_path={@current_path}
    >
      <div class="max-w-6xl mx-auto px-4 py-8">
        <!-- Header -->
        <div class="mb-8">
          <h1 class="text-3xl font-bold text-base-content mb-2">
            {gettext("Account Settings")}
          </h1>
          <p class="text-base-content/60">
            {gettext("Manage your account email address and password settings")}
          </p>
        </div>
        
    <!-- Settings Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <!-- Email Settings -->
          <div class="card bg-base-100 shadow-md border border-base-200">
            <div class="card-body">
              <h2 class="card-title text-lg mb-4">{gettext("Email Address")}</h2>
              <.form
                for={@email_form}
                id="email_form"
                phx-submit="update_email"
                phx-change="validate_email"
              >
                <.input
                  field={@email_form[:email]}
                  type="email"
                  label={gettext("Email")}
                  autocomplete="username"
                  required
                />
                <.button class="btn btn-primary w-full mt-4" phx-disable-with={gettext("Changing...")}>
                  {gettext("Change Email")}
                </.button>
              </.form>
            </div>
          </div>
          
    <!-- Password Settings -->
          <div class="card bg-base-100 shadow-md border border-base-200">
            <div class="card-body">
              <h2 class="card-title text-lg mb-4">{gettext("Password")}</h2>
              <.form
                for={@password_form}
                id="password_form"
                action={~p"/admin/update-password"}
                method="post"
                phx-change="validate_password"
                phx-submit="update_password"
                phx-trigger-action={@trigger_submit}
              >
                <input
                  name={@password_form[:email].name}
                  type="hidden"
                  id="hidden_user_email"
                  autocomplete="username"
                  value={@current_email}
                />
                <.input
                  field={@password_form[:password]}
                  type="password"
                  label={gettext("New password")}
                  autocomplete="new-password"
                  required
                />
                <.input
                  field={@password_form[:password_confirmation]}
                  type="password"
                  label={gettext("Confirm new password")}
                  autocomplete="new-password"
                />
                <.button class="btn btn-primary w-full mt-4" phx-disable-with={gettext("Saving...")}>
                  {gettext("Save Password")}
                </.button>
              </.form>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_scope.user, token) do
        {:ok, _user} ->
          put_flash(socket, :info, gettext("Email changed successfully."))

        {:error, _} ->
          put_flash(socket, :error, gettext("Email change link is invalid or it has expired."))
      end

    {:ok, push_navigate(socket, to: ~p"/admin/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_scope.user
    email_changeset = Accounts.change_user_email(user, %{}, validate_unique: false)
    password_changeset = Accounts.change_user_password(user, %{}, hash_password: false)

    socket =
      socket
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate_email", params, socket) do
    %{"user" => user_params} = params

    email_form =
      socket.assigns.current_scope.user
      |> Accounts.change_user_email(user_params, validate_unique: false)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form)}
  end

  def handle_event("update_email", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_scope.user
    true = Accounts.sudo_mode?(user)

    case Accounts.change_user_email(user, user_params) do
      %{valid?: true} = changeset ->
        Accounts.deliver_user_update_email_instructions(
          Ecto.Changeset.apply_action!(changeset, :insert),
          user.email,
          &url(~p"/admin/settings/confirm-email/#{&1}")
        )

        info = gettext("A link to confirm your email change has been sent to the new address.")
        {:noreply, socket |> put_flash(:info, info)}

      changeset ->
        {:noreply, assign(socket, :email_form, to_form(changeset, action: :insert))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"user" => user_params} = params

    password_form =
      socket.assigns.current_scope.user
      |> Accounts.change_user_password(user_params, hash_password: false)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form)}
  end

  def handle_event("update_password", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_scope.user
    true = Accounts.sudo_mode?(user)

    case Accounts.change_user_password(user, user_params) do
      %{valid?: true} = changeset ->
        {:noreply, assign(socket, trigger_submit: true, password_form: to_form(changeset))}

      changeset ->
        {:noreply, assign(socket, password_form: to_form(changeset, action: :insert))}
    end
  end

  @impl true
  def handle_params(_params, uri, socket) do
    {:noreply, assign(socket, current_path: URI.parse(uri).path)}
  end
end
