defmodule TremtecWeb.Admin.MessagesLive.IndexLive do
  use TremtecWeb, :live_view

  alias Tremtec.Date
  alias Tremtec.Messages

  @per_page 10
  @max_message_length 50

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
          <h1 class="text-3xl font-bold text-base-content mb-4">
            {gettext("Messages")}
          </h1>
          
    <!-- Search -->
          <.form for={@search_form} phx-change="search" class="flex gap-2">
            <div class="flex-1">
              <.input
                field={@search_form[:q]}
                type="text"
                placeholder={gettext("Search by name, email, or message content")}
              />
            </div>
            <button
              :if={@search != ""}
              type="button"
              phx-click="clear_search"
              class="btn btn-sm btn-ghost"
              title={gettext("Clear search")}
            >
              <.icon name="hero-x-mark" class="w-4 h-4" />
            </button>
          </.form>
        </div>
        
    <!-- Messages Table -->
        <div class="card bg-base-100 shadow-md border border-base-200">
          <div class="overflow-x-auto">
            <table class="table w-full">
              <thead>
                <tr class="border-b border-base-300">
                  <th class="text-left">{gettext("Name")}</th>
                  <th class="text-left">{gettext("Email")}</th>
                  <th class="text-left">{gettext("Message")}</th>
                  <th class="text-center">{gettext("Status")}</th>
                  <th class="text-left">{gettext("Date")}</th>
                  <th class="text-center">{gettext("Actions")}</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  :for={message <- @messages}
                  class="border-b border-base-200 hover:bg-base-200/50 cursor-pointer"
                >
                  <td class="font-medium">
                    <.link navigate={~p"/admin/messages/#{message.id}"} class="link link-hover">
                      {message.name}
                    </.link>
                  </td>
                  <td class="text-sm text-base-content/70">
                    <.link navigate={~p"/admin/messages/#{message.id}"} class="link link-hover">
                      {message.email}
                    </.link>
                  </td>
                  <td class="text-sm truncate">
                    <.link navigate={~p"/admin/messages/#{message.id}"} class="link link-hover">
                      {truncate_message(message.message)}
                    </.link>
                  </td>
                  <td class="text-center">
                    <.status_badge
                      status={message.read}
                      label_true={gettext("Read")}
                      label_false={gettext("Unread")}
                    />
                  </td>
                  <td class="text-sm text-base-content/60">
                    {Date.format_full_date(message.inserted_at)}
                  </td>
                  <td class="text-center">
                    <div class="flex gap-2 justify-center">
                      <.link
                        href="#"
                        phx-click="toggle_read"
                        phx-value-id={message.id}
                        class="btn btn-xs btn-ghost"
                        title={gettext("Toggle read status")}
                      >
                        <.icon
                          name={if message.read, do: "hero-eye-slash", else: "hero-eye"}
                          class="w-4 h-4"
                        />
                      </.link>

                      <.link
                        href="#"
                        phx-click="show_delete_modal"
                        phx-value-id={message.id}
                        class="btn btn-xs btn-error btn-ghost"
                        title={gettext("Delete message")}
                      >
                        <.icon name="hero-trash" class="w-4 h-4" />
                      </.link>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          
    <!-- Empty State -->
          <div :if={Enum.empty?(@messages)} class="p-8 text-center">
            <.icon name="hero-inbox" class="w-12 h-12 mx-auto text-base-content/20 mb-3" />
            <p class="text-base-content/60">{gettext("No messages found")}</p>
          </div>
        </div>
        
    <!-- Pagination -->
        <div :if={@total_pages > 1} class="mt-8">
          <TremtecWeb.Components.Pagination.controls
            current_page={@page}
            total_pages={@total_pages}
          />
        </div>
      </div>

      <TremtecWeb.Components.DeleteModal.confirm
        show={@show_delete_modal}
        modal_id={@delete_modal_id}
        message={
          gettext("Are you sure you want to delete this message? This action cannot be undone.")
        }
      />
    </Layouts.app>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        page: 1,
        search: "",
        show_delete_modal: false,
        delete_modal_id: nil,
        search_form: to_form(%{"q" => ""}, as: :search)
      )
      |> load_messages()

    {:ok, socket}
  end

  def handle_event("search", %{"search" => %{"q" => q}}, socket) do
    socket =
      socket
      |> assign(search: q, page: 1, search_form: to_form(%{"q" => q}, as: :search))
      |> load_messages()

    {:noreply, socket}
  end

  def handle_event("clear_search", _params, socket) do
    socket =
      socket
      |> assign(search: "", page: 1, search_form: to_form(%{"q" => ""}, as: :search))
      |> load_messages()

    {:noreply, socket}
  end

  def handle_event("next_page", _params, socket) do
    socket =
      socket
      |> assign(page: socket.assigns.page + 1)
      |> load_messages()

    {:noreply, socket}
  end

  def handle_event("prev_page", _params, socket) do
    socket =
      socket
      |> assign(page: socket.assigns.page - 1)
      |> load_messages()

    {:noreply, socket}
  end

  def handle_event("toggle_read", %{"id" => id}, socket) do
    case Messages.get_contact_message(id) do
      {:ok, message} ->
        case Messages.mark_message_read(message, !message.read) do
          {:ok, _updated} ->
            status_msg =
              if message.read,
                do: gettext("Marked as unread"),
                else: gettext("Marked as read")

            socket =
              socket
              |> load_messages()
              |> put_flash(:info, status_msg)

            {:noreply, socket}

          {:error, _changeset} ->
            {:noreply, put_flash(socket, :error, gettext("Failed to update message status"))}
        end

      :error ->
        {:noreply, put_flash(socket, :error, gettext("Message not found"))}
    end
  end

  def handle_event("show_delete_modal", %{"id" => id}, socket) do
    {:noreply, socket |> assign(show_delete_modal: true, delete_modal_id: id)}
  end

  def handle_event("close_delete_modal", _params, socket) do
    {:noreply, socket |> assign(show_delete_modal: false, delete_modal_id: nil)}
  end

  def handle_event("confirm_delete", %{"id" => id}, socket) do
    case Messages.get_contact_message(id) do
      {:ok, message} ->
        case Messages.delete_admin_message(message) do
          {:ok, _deleted} ->
            socket =
              socket
              |> assign(show_delete_modal: false, delete_modal_id: nil)
              |> load_messages()
              |> put_flash(:info, gettext("Message deleted successfully"))

            {:noreply, socket}

          {:error, _changeset} ->
            {:noreply, put_flash(socket, :error, gettext("Failed to delete message"))}
        end

      :error ->
        socket =
          socket
          |> assign(show_delete_modal: false, delete_modal_id: nil)
          |> put_flash(:warning, gettext("Message was already deleted"))

        {:noreply, socket}
    end
  end

  defp load_messages(socket) do
    search = socket.assigns.search
    page = socket.assigns.page

    {messages, total_count} =
      if search == "" or search == nil do
        Messages.list_admin_messages(page, @per_page)
      else
        Messages.search_admin_messages(search, page, @per_page)
      end

    total_pages = ceil(total_count / @per_page)

    socket
    |> assign(
      messages: messages,
      total_count: total_count,
      total_pages: total_pages
    )
  end

  defp truncate_message(message), do: truncate_message(message, @max_message_length)

  defp truncate_message(message, max_length) do
    if String.length(message) > max_length do
      String.slice(message, 0, max_length - 3) <> "..."
    else
      message
    end
  end

  def handle_params(_params, uri, socket) do
    {:noreply, assign(socket, current_path: URI.parse(uri).path)}
  end
end
