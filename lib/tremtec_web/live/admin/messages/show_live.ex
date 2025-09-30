defmodule TremtecWeb.Admin.Messages.ShowLive do
  use TremtecWeb, :live_view

  require Logger

  alias Tremtec.Messages

  @impl true
  def mount(%{"id" => id}, %{"locale" => locale}, socket) do
    Logger.info("Mounting message show live with locale: #{locale}")
    Gettext.put_locale(TremtecWeb.Gettext, locale)

    msg = Messages.get_contact_message!(id)
    {:ok, assign(socket, page_title: gettext("Message"), msg: msg)}
  end

  @impl true
  def handle_event("toggle-read", _params, %{assigns: %{msg: msg}} = socket) do
    {:ok, msg} = Messages.update_contact_message(msg, %{read: !msg.read})
    {:noreply, assign(socket, :msg, msg)}
  end
end
