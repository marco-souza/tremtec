defmodule TremtecWeb.RestoreLocale do
  @moduledoc """
  Restores the locale from the session and sets it for the current LiveView process.
  """
  import Phoenix.Component, only: [assign: 3]
  import Phoenix.LiveView, only: [attach_hook: 4]

  def on_mount(:default, _params, session, socket) do
    locale = session["locale"] || Tremtec.Config.default_locale()
    Gettext.put_locale(TremtecWeb.Gettext, locale)

    {:cont,
     socket
     |> assign(:locale, locale)
     |> attach_hook(:set_locale, :handle_params, &handle_params/3)}
  end

  defp handle_params(_params, _url, socket) do
    # Ensure locale persists across navigation
    Gettext.put_locale(TremtecWeb.Gettext, socket.assigns.locale)
    {:cont, socket}
  end
end
