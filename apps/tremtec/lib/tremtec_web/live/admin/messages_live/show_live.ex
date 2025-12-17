defmodule TremtecWeb.Admin.MessagesLive.ShowLive do
  use TremtecWeb, :live_view

  alias Tremtec.Messages
  alias Tremtec.Date

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} is_admin={true} current_path={@current_path}>
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
                  {Date.format_full_date(@message.inserted_at)}
                </p>
              </div>

              <div>
                <p class="text-sm text-base-content/60 mb-1">{gettext("Status")}</p>
                <.status_badge
                  status={@message.read}
                  label_true={gettext("Read")}
                  label_false={gettext("Unread")}
                />
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

        <TremtecWeb.Components.DeleteModal.confirm
          show={@show_delete_modal}
          modal_id={@message.id}
          message={
            gettext("Are you sure you want to delete this message? This action cannot be undone.")
          }
        />
      </div>
    </Layouts.app>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    case Messages.get_contact_message(id) do
      {:ok, message} ->
        {:ok,
         socket
         |> assign(
           message: message,
           page_title: gettext("Message"),
           show_delete_modal: false
         )}

      :error ->
        {:error, redirect(socket, to: ~p"/admin/messages")}
    end
  end

  def handle_event("toggle_read", _params, socket) do
    message = socket.assigns.message

    case Messages.mark_message_read(message, !message.read) do
      {:ok, _updated} ->
        case Messages.get_contact_message(message.id) do
          {:ok, refreshed_message} ->
            status_msg =
              if message.read,
                do: gettext("Marked as unread"),
                else: gettext("Marked as read")

            socket =
              socket
              |> assign(message: refreshed_message)
              |> put_flash(:info, status_msg)

            {:noreply, socket}

          :error ->
            {:noreply, put_flash(socket, :error, gettext("Message not found"))}
        end

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, gettext("Failed to update message status"))}
    end
  end

  def handle_event("show_delete_modal", _params, socket) do
    {:noreply, socket |> assign(show_delete_modal: true)}
  end

  def handle_event("close_delete_modal", _params, socket) do
    {:noreply, socket |> assign(show_delete_modal: false)}
  end

  def handle_event("confirm_delete", %{"id" => _id}, socket) do
    message = socket.assigns.message

    case Messages.delete_admin_message(message) do
      {:ok, _deleted} ->
        socket =
          socket
          |> put_flash(:info, gettext("Message deleted successfully"))

        {:noreply, push_navigate(socket, to: ~p"/admin/messages")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, gettext("Failed to delete message"))}
    end
  end

  def handle_params(_params, uri, socket) do
    {:noreply, assign(socket, current_path: URI.parse(uri).path)}
  end
end
