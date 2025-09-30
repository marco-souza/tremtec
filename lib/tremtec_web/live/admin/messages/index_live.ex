defmodule TremtecWeb.Admin.Messages.IndexLive do
  use TremtecWeb, :live_view

  require Logger

  alias Tremtec.Messages

  @impl true
  def mount(_params, %{"locale" => locale}, socket) do
    Logger.info("Mounting contact live with locale: #{locale}")
    Gettext.put_locale(TremtecWeb.Gettext, locale)

    {:ok,
     socket
     |> assign(:page_title, gettext("Contact Messages"))
     |> stream(:messages, Messages.list_contact_messages())
     |> assign(:locale, Gettext.get_locale())
     |> assign(:search, to_form(%{"q" => ""}, as: :search))}
  end

  @impl true
  def handle_event("search", %{"search" => %{"q" => q}}, socket) do
    messages = Messages.list_contact_messages(email: q, name: q)
    {:noreply, stream(socket, :messages, messages, reset: true)}
  end
end
