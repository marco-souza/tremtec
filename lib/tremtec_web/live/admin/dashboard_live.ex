defmodule TremtecWeb.Admin.DashboardLive do
  use TremtecWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} is_admin={true}>
      <div class="max-w-7xl mx-auto px-4 py-8">
        <!-- Header -->
        <div class="mb-12">
          <h1 class="text-4xl font-bold text-base-content mb-2">
            {gettext("Admin Dashboard")}
          </h1>
          <p class="text-base-content/60">
            {gettext("Welcome back,")} {@current_scope.user.email}
          </p>
        </div>
        
    <!-- Statistics Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
          <.stat_card
            title={gettext("Total Users")}
            value={@total_users}
            icon="hero-users"
          />

          <.stat_card
            title={gettext("Total Messages")}
            value={@total_messages}
            icon="hero-envelope"
          />

          <.stat_card
            title={gettext("Unread Messages")}
            value={@unread_messages}
            icon="hero-bell"
          />

          <.stat_card
            title={gettext("Last Message")}
            value={@last_message_date || gettext("No messages")}
            icon="hero-calendar"
          />
        </div>
        
    <!-- Quick Actions -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <.action_card
            title={gettext("Manage Messages")}
            description={gettext("View and manage contact messages")}
            href={~p"/admin/messages"}
            icon="hero-envelope-open"
          />

          <.action_card
            title={gettext("Manage Users")}
            description={gettext("View and manage registered users")}
            href={~p"/admin/users"}
            icon="hero-users"
          />
        </div>
      </div>
    </Layouts.app>
    """
  end

  attr :title, :string, required: true
  attr :value, :any, required: true
  attr :icon, :string, required: true

  defp stat_card(assigns) do
    ~H"""
    <div class="card bg-base-100 shadow-md border border-base-200">
      <div class="card-body">
        <div class="flex items-center justify-between">
          <div>
            <div class="text-sm text-base-content/60">{@title}</div>
            <div class="text-3xl font-bold text-base-content">
              {@value}
            </div>
          </div>
          <.icon name={@icon} class="w-12 h-12 text-primary/30" />
        </div>
      </div>
    </div>
    """
  end

  attr :title, :string, required: true
  attr :description, :string, required: true
  attr :href, :string, required: true
  attr :icon, :string, required: true

  defp action_card(assigns) do
    ~H"""
    <div class="card bg-base-100 shadow-md border border-base-200 hover:border-primary transition-colors">
      <div class="card-body">
        <div class="flex items-start justify-between">
          <div>
            <h3 class="card-title text-lg">{@title}</h3>
            <p class="text-sm text-base-content/60 mt-1">{@description}</p>
          </div>
          <.icon name={@icon} class="w-10 h-10 text-primary/40" />
        </div>
        <div class="card-actions justify-end mt-4">
          <.link navigate={@href} class="btn btn-primary btn-sm">
            {gettext("Go to")} <.icon name="hero-arrow-right" class="w-4 h-4 ml-2" />
          </.link>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {_total_users, total_users_count} = Tremtec.Accounts.list_users(1, 1000)
    {_messages, total_messages_count} = Tremtec.Messages.list_admin_messages(1, 1000)
    unread_messages = Tremtec.Messages.count_unread_messages()
    last_message_date = Tremtec.Messages.get_last_message_date()

    {:ok,
     socket
     |> assign(
       total_users: total_users_count,
       total_messages: total_messages_count,
       unread_messages: unread_messages,
       last_message_date: format_date(last_message_date)
     )}
  end

  defp format_date(nil), do: nil

  defp format_date(date) when is_struct(date, DateTime) do
    date |> Calendar.strftime("%Y-%m-%d %H:%M")
  end

  defp format_date(date) when is_struct(date, NaiveDateTime) do
    date |> Calendar.strftime("%Y-%m-%d %H:%M")
  end

  defp format_date(_), do: nil
end
