defmodule TremtecWeb.Components.AdminNavMobile do
  use TremtecWeb, :html

  @doc """
  Renders a mobile bottom navigation bar for admin.

  Only visible on screens smaller than md.
  """
  def admin_nav_mobile(assigns) do
    ~H"""
    <nav class="md:hidden fixed bottom-0 left-0 right-0 bg-base-100 border-t border-base-200 flex justify-around items-center h-16 z-40">
      <.nav_button href={~p"/admin/dashboard"} icon="hero-home" label={gettext("Dashboard")} />
      <.nav_button href={~p"/admin/messages"} icon="hero-envelope" label={gettext("Messages")} />
      <.nav_button href={~p"/admin/users"} icon="hero-users" label={gettext("Users")} />
      <.nav_button href={~p"/admin/settings"} icon="hero-cog-6-tooth" label={gettext("Settings")} />
      
    <!-- More Menu -->
      <div class="dropdown dropdown-top">
        <button
          class="flex flex-col items-center gap-1 text-base-content/70 hover:text-primary transition-colors py-1"
          tabindex="0"
        >
          <.icon name="hero-ellipsis-vertical" class="w-6 h-6" />
          <span class="text-xs">{gettext("More")}</span>
        </button>
        <ul
          tabindex="0"
          class="dropdown-content z-50 menu p-2 shadow bg-base-100 rounded-box w-52 border border-base-200"
        >
          <li>
            <.link navigate={~p"/"} class="justify-between">
              {gettext("Back to Page")}
              <.icon name="hero-arrow-left" class="w-4 h-4" />
            </.link>
          </li>
          <li>
            <.link method="delete" href={~p"/admin/log-out"} class="justify-between">
              {gettext("Logout")}
              <.icon name="hero-arrow-right-on-rectangle" class="w-4 h-4" />
            </.link>
          </li>
        </ul>
      </div>
    </nav>

    <!-- Padding to prevent content overlap -->
    <div class="md:hidden h-16" />
    """
  end

  attr :href, :string, required: true
  attr :icon, :string, required: true
  attr :label, :string, required: true

  defp nav_button(assigns) do
    ~H"""
    <.link
      navigate={@href}
      class="flex flex-col items-center gap-1 text-base-content/70 hover:text-primary transition-colors py-1"
    >
      <.icon name={@icon} class="w-6 h-6" />
      <span class="text-xs hidden sm:inline">{@label}</span>
    </.link>
    """
  end
end
