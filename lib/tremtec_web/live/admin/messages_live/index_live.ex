defmodule TremtecWeb.Admin.MessagesLive.IndexLive do
  use TremtecWeb, :live_view

  alias Tremtec.Messages

  @per_page 10

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} is_admin={true}>
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
                <tr :for={message <- @messages} class="border-b border-base-200 hover:bg-base-200/50 cursor-pointer">
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
                  <td class="text-sm max-w-xs truncate">
                    <.link navigate={~p"/admin/messages/#{message.id}"} class="link link-hover">
                      {message.message}
                    </.link>
                  </td>
                  <td class="text-center">
                    <.status_badge read={message.read} />
                  </td>
                  <td class="text-sm text-base-content/60">
                    {Calendar.strftime(message.inserted_at, "%Y-%m-%d %H:%M")}
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
        <div :if={@total_pages > 1} class="flex justify-center gap-2 mt-8">
          <.link
            :if={@page > 1}
            href="#"
            phx-click="prev_page"
            class="btn btn-sm btn-outline"
          >
            {gettext("Previous")}
          </.link>

          <div class="flex items-center gap-1">
            <span class="text-sm text-base-content/70">
              {gettext("Page")} {@page} {gettext("of")} {@total_pages}
            </span>
          </div>

          <.link
            :if={@page < @total_pages}
            href="#"
            phx-click="next_page"
            class="btn btn-sm btn-outline"
          >
            {gettext("Next")}
          </.link>
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
            <button
              class="btn btn-outline"
              phx-click="close_delete_modal"
            >
              {gettext("Cancel")}
            </button>
            <button
              class="btn btn-error"
              phx-click="confirm_delete"
              phx-value-id={@delete_modal_id}
            >
              {gettext("Delete")}
            </button>
          </div>
        </div>
        <form method="dialog" class="modal-backdrop">
          <button phx-click="close_delete_modal">{gettext("Close")}</button>
        </form>
      </div>
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
      |> assign(search: q, page: 1)
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
    message = Messages.get_contact_message!(id)
    Messages.mark_message_read(message, !message.read)

    socket = socket |> load_messages()

    {:noreply, socket}
  end

  def handle_event("show_delete_modal", %{"id" => id}, socket) do
    {:noreply, socket |> assign(show_delete_modal: true, delete_modal_id: id)}
  end

  def handle_event("close_delete_modal", _params, socket) do
    {:noreply, socket |> assign(show_delete_modal: false, delete_modal_id: nil)}
  end

  def handle_event("confirm_delete", %{"id" => id}, socket) do
    message = Messages.get_contact_message!(id)
    Messages.delete_admin_message(message)

    socket =
      socket
      |> assign(show_delete_modal: false, delete_modal_id: nil)
      |> load_messages()

    {:noreply, socket}
  end

  defp load_messages(socket) do
    search = socket.assigns.search
    page = socket.assigns.page

    {messages, total_count} =
      if search == "" or search == nil do
        Messages.list_admin_messages(page, @per_page)
      else
        all_results = Messages.search_admin_messages(search)
        offset = (page - 1) * @per_page
        total = Enum.count(all_results)

        paginated =
          all_results
          |> Enum.drop(offset)
          |> Enum.take(@per_page)

        {paginated, total}
      end

    total_pages = ceil(total_count / @per_page)

    socket
    |> assign(
      messages: messages,
      total_count: total_count,
      total_pages: total_pages
    )
  end

  defp status_badge(%{read: true} = assigns) do
    ~H"""
    <span class="badge badge-success">{gettext("Read")}</span>
    """
  end

  defp status_badge(%{read: false} = assigns) do
    ~H"""
    <span class="badge badge-warning">{gettext("Unread")}</span>
    """
  end
end
