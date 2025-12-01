defmodule TremtecWeb.Admin.DashboardLive do
  use TremtecWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="flex items-center justify-center min-h-screen">
        <div class="text-center">
          <h1 class="text-4xl font-bold mb-4">Under Construction</h1>
          <p class="text-gray-600">Dashboard coming soon...</p>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
