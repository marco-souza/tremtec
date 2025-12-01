defmodule TremtecWeb.Admin.MessagesLive.ShowLive do
  use TremtecWeb, :live_view

  alias Tremtec.Messages

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} is_admin={true}>
      <div class="max-w-3xl mx-auto px-4 py-8">
        <!-- Back Button -->
        <div class="mb-6">
          <.link navigate={~p"/admin/messages"} class="btn btn-ghost btn-sm">
            <.icon name="hero-arrow-left" class="w-4 h-4" />
            {gettext("Back to Messages")}
          </.link>
        </div>

        <div class="card bg-base-100 shadow-md border border-base-200">
          <div class="card-body">
            <!-- Header Info -->
            <div class="grid grid-cols-2 gap-4 mb-6 pb-6 border-b border-base-300">
              <div>
                <p class="text-sm text-base-content/60 mb-1">{gettext("From")}</p>
                <p class="font-medium">{@message.name}</p>
                <p class="text-sm text-base-content/70">{@message.email}</p>
              </div>

              <div>
                <p class="text-sm text-base-content/60 mb-1">{gettext("Received")}</p>
                <p class="font-medium">
                  {Calendar.strftime(@message.inserted_at, "%Y-%m-%d %H:%M:%S")}
                </p>
              </div>

              <div>
                <p class="text-sm text-base-content/60 mb-1">{gettext("Status")}</p>
                <span class={[
                  "badge",
                  @message.read && "badge-success",
                  !@message.read && "badge-warning"
                ]}>
                  {if @message.read, do: gettext("Read"), else: gettext("Unread")}
                </span>
              </div>
            </div>
            
    <!-- Message Content -->
            <div class="mb-6">
              <p class="text-sm text-base-content/60 mb-3">{gettext("Message")}</p>
              <div class="bg-base-200 rounded-lg p-6 whitespace-pre-wrap">
                {@message.message}
              </div>
            </div>
            
    <!-- Actions -->
            <div class="flex gap-3 justify-end">
              <button
                phx-click="toggle_read"
                class="btn btn-outline btn-sm"
              >
                <.icon
                  name={if @message.read, do: "hero-eye-slash", else: "hero-eye"}
                  class="w-4 h-4"
                />
                {if @message.read, do: gettext("Mark as Unread"), else: gettext("Mark as Read")}
              </button>

              <button
                phx-click="show_delete_modal"
                class="btn btn-error btn-outline btn-sm"
              >
                <.icon name="hero-trash" class="w-4 h-4" />
                {gettext("Delete")}
              </button>
            </div>
          </div>
        </div>
        
    <!-- Delete Confirmation Modal -->
        <div
          :if={@show_delete_modal}
          class="modal modal-open"
          id="delete-modal"
        >
          <div class="modal-box">
            <h3 class="font-bold text-lg">{gettext("Confirm Deletion")}</h3>
            <p class="py-4">
              {gettext("Are you sure you want to delete this message? This action cannot be undone.")}
            </p>
            <div class="modal-action">
              <button class="btn btn-outline" phx-click="close_delete_modal">
                {gettext("Cancel")}
              </button>
              <button class="btn btn-error" phx-click="confirm_delete">
                {gettext("Delete")}
              </button>
            </div>
          </div>
          <form method="dialog" class="modal-backdrop">
            <button phx-click="close_delete_modal">{gettext("Close")}</button>
          </form>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    message = Messages.get_contact_message!(id)

    {:ok,
     socket
     |> assign(
       message: message,
       page_title: gettext("Message"),
       show_delete_modal: false
     )}
  end

  def handle_event("toggle_read", _params, socket) do
    message = socket.assigns.message
    Messages.mark_message_read(message, !message.read)
    updated_message = Messages.get_contact_message!(message.id)

    {:noreply, socket |> assign(message: updated_message)}
  end

  def handle_event("show_delete_modal", _params, socket) do
    {:noreply, socket |> assign(show_delete_modal: true)}
  end

  def handle_event("close_delete_modal", _params, socket) do
    {:noreply, socket |> assign(show_delete_modal: false)}
  end

  def handle_event("confirm_delete", _params, socket) do
    message = socket.assigns.message
    Messages.delete_admin_message(message)

    {:noreply, push_navigate(socket, to: ~p"/admin/messages")}
  end
end
