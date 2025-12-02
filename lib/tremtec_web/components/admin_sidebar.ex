defmodule TremtecWeb.Components.AdminSidebar do
  use TremtecWeb, :html

  @doc """
  Renders a desktop sidebar for admin navigation.

  Only visible on md+ screens.
  """
  def admin_sidebar(assigns) do
    ~H"""
    <aside class="hidden md:flex fixed left-0 top-0 h-screen w-64 bg-base-100 border-r border-base-200 flex-col z-40">
      <!-- Branding Section -->
      <div class="px-6 py-8 border-b border-base-200 flex items-center gap-3">
        <.icon name="hero-command-line" class="w-8 h-8 text-primary" />
        <span class="text-xl font-bold text-base-content">TremTec</span>
      </div>

      <nav class="flex-1 px-6 py-8">
        <div class="space-y-2">
          <.nav_link href={~p"/admin/dashboard"} icon="hero-home">
            {gettext("Dashboard")}
          </.nav_link>

          <.nav_link href={~p"/admin/messages"} icon="hero-envelope">
            {gettext("Messages")}
          </.nav_link>

          <.nav_link href={~p"/admin/users"} icon="hero-users">
            {gettext("Users")}
          </.nav_link>

          <.nav_link href={~p"/admin/settings"} icon="hero-cog-6-tooth">
            {gettext("Settings")}
          </.nav_link>
        </div>
      </nav>
      
    <!-- Footer Links -->
      <div class="px-6 py-8 border-t border-base-200 space-y-2">
        <.nav_link href={~p"/"} icon="hero-arrow-left">
          {gettext("Back to Page")}
        </.nav_link>

        <.link
          method="delete"
          href={~p"/admin/log-out"}
          class="flex items-center gap-3 px-3 py-2 rounded-lg text-base-content/70 hover:bg-base-200 transition-colors"
        >
          <.icon name="hero-arrow-right-on-rectangle" class="w-5 h-5" />
          <span>{gettext("Logout")}</span>
        </.link>
      </div>
    </aside>
    """
  end

  attr :href, :string, required: true
  attr :icon, :string, required: true
  slot :inner_block, required: true

  defp nav_link(assigns) do
    ~H"""
    <.link
      navigate={@href}
      class="flex items-center gap-3 px-3 py-2 rounded-lg text-base-content/70 hover:bg-base-200 transition-colors"
    >
      <.icon name={@icon} class="w-5 h-5" />
      <span>{render_slot(@inner_block)}</span>
    </.link>
    """
  end
end
