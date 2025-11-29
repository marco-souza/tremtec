defmodule TremtecWeb.Admin.Messages.IndexLive do
  use TremtecWeb, :live_view

  require Logger

  alias Tremtec.Messages

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <div class="max-w-5xl mx-auto px-4 py-10">
        <.header>
          {gettext("Contact Messages")}
          <:actions>
            <.form for={@search} phx-change="search" id="search-form" class="flex gap-2 items-end">
              <.input field={@search[:q]} placeholder={gettext("Search by name or email")} />
            </.form>
          </:actions>
        </.header>

        <div id="messages" phx-update="stream" class="divide-y divide-base-300">
          <div :for={{id, m} <- @streams.messages} id={id} class="py-4">
            <.link navigate={~p"/admin/messages/#{m.id}"}>
              <div class="flex items-start gap-4">
                <div class="flex-1">
                  <div class="font-medium">{m.name} <span class="opacity-60">{m.email}</span></div>
                  <div class="text-sm opacity-80 truncate">{m.message}</div>
                </div>
                <div class="text-xs opacity-60">
                  {Calendar.strftime(m.inserted_at, "%Y-%m-%d %H:%M")}
                </div>
              </div>
            </.link>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, gettext("Contact Messages"))
     |> stream(:messages, Messages.list_contact_messages())
     |> assign(:search, to_form(%{"q" => ""}, as: :search))}
  end

  @impl true
  def handle_event("search", %{"search" => %{"q" => q}}, socket) do
    messages = Messages.list_contact_messages(email: q, name: q)
    {:noreply, stream(socket, :messages, messages, reset: true)}
  end
end
