defmodule TremtecWeb.Admin.Messages.ShowLive do
  use TremtecWeb, :live_view

  require Logger

  alias Tremtec.Messages

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="max-w-3xl mx-auto px-4 py-10 space-y-6">
        <.header>
          {gettext("Message")}
          <:actions>
            <.button navigate={~p"/admin/messages"}>
              {gettext("Back")}
            </.button>
          </:actions>
        </.header>

        <.list>
          <:item title={gettext("From")}>{@msg.name} &lt;{@msg.email}&gt;</:item>
          <:item title={gettext("Received")}>
            {Calendar.strftime(@msg.inserted_at, "%Y-%m-%d %H:%M")}
          </:item>
          <:item title={gettext("Status")}>
            {if @msg.read, do: gettext("Read"), else: gettext("Unread")}
          </:item>
        </.list>

        <div class="prose max-w-none whitespace-pre-wrap">{@msg.message}</div>

        <.button phx-click="toggle-read" id="toggle-read">
          {if @msg.read, do: gettext("Mark as unread"), else: gettext("Mark as read")}
        </.button>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    msg = Messages.get_contact_message!(id)
    {:ok, assign(socket, page_title: gettext("Message"), msg: msg)}
  end

  @impl true
  def handle_event("toggle-read", _params, %{assigns: %{msg: msg}} = socket) do
    {:ok, msg} = Messages.update_contact_message(msg, %{read: !msg.read})
    {:noreply, assign(socket, :msg, msg)}
  end
end
