defmodule TremtecWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use TremtecWeb, :html

  import TremtecWeb.Components.AdminSidebar
  import TremtecWeb.Components.AdminNavMobile

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  attr :is_admin, :boolean,
    default: false,
    doc: "whether this is an admin page"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div class={["bg-base-100", @is_admin && "md:ml-64"]}>
      <!-- Admin Sidebar (Desktop) -->
      <.admin_sidebar :if={@is_admin} />
      
    <!-- Admin Mobile Nav -->
      <.admin_nav_mobile :if={@is_admin} />
      
    <!-- Public Layout -->
      <div :if={!@is_admin} class="drawer">
        <input id="mobile-drawer" type="checkbox" class="drawer-toggle" />

        <div class="drawer-content flex flex-col min-h-screen">
          <.navbar current_scope={@current_scope} />

          <main class="flex-1 mt-20 py-8">
            {render_slot(@inner_block)}
          </main>

          <.footer />
        </div>

        <.drawer current_scope={@current_scope} />
      </div>
      
    <!-- Admin Layout -->
      <div :if={@is_admin} class="flex flex-col min-h-screen">
        <main class="flex-1 py-8">
          {render_slot(@inner_block)}
        </main>
      </div>
    </div>

    <.flash_group flash={@flash} />
    """
  end

  def logo(assigns) do
    ~H"""
    <a href="/" class="flex items-center gap-2">
      <img src={~p"/images/logo.png"} width="48" alt="TremTec Logo" />
      <span class="text-lg font-bold">TremTec</span>
    </a>
    """
  end

  def drawer(assigns) do
    ~H"""
    <div class="drawer-side z-50">
      <label for="mobile-drawer" class="drawer-overlay"></label>

      <ul class="menu p-4 w-80 min-h-full bg-base-200 gap-2 flex flex-col">
        <div class="spacer mt-4 mb-8">
          <.logo />
        </div>

        <li :for={link <- nav_links()}>
          <a
            href={link.href}
            class="text-lg font-medium"
            onclick="document.getElementById('mobile-drawer').click()"
          >
            {link.label}
          </a>
        </li>

        <div class="spacer flex-1" />

        <%= if @current_scope && @current_scope.user do %>
          <li>
            <.link
              navigate={~p"/admin/dashboard"}
              class="text-lg font-medium"
              onclick="document.getElementById('mobile-drawer').click()"
            >
              <span class="text-sm text-base-content/80">{@current_scope.user.email}</span>
            </.link>
            <.link
              method="delete"
              href={~p"/admin/log-out"}
              class="text-sm font-medium text-base-content/80 hover:text-primary transition-colors"
            >
              {gettext("Log out")}
            </.link>
          </li>
        <% else %>
          <li class="mt-4 pt-4 border-t border-base-300">
            <.link
              navigate={~p"/admin"}
              class="text-lg font-medium"
              onclick="document.getElementById('mobile-drawer').click()"
            >
              {gettext("Log in")}
            </.link>
            <a href="#contact" class="btn btn-primary btn-sm font-medium px-6">
              {gettext("Get Started")}
            </a>
          </li>
        <% end %>

        <li><.theme_toggle /></li>
      </ul>
    </div>
    """
  end

  def navbar(assigns) do
    ~H"""
    <div class="navbar fixed top-0 w-full z-50 transition-all duration-300 bg-base-100/80 backdrop-blur-md border-b border-base-200/50">
      <div class="max-w-7xl mx-auto w-full px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16 items-center w-full">
          <!-- Left: Logo -->
          <div class="flex-shrink-0 flex items-center gap-2">
            <.logo />
          </div>
          
    <!-- Center: Navigation (Desktop) -->
          <div class="hidden md:flex items-center space-x-8">
            <a
              :for={link <- nav_links()}
              href={link.href}
              class="text-sm font-medium text-base-content/80 hover:text-primary transition-colors"
            >
              {link.label}
            </a>
          </div>
          
    <!-- Right: CTA & Theme -->
          <div class="hidden md:flex items-center gap-4">
            <%= if @current_scope && @current_scope.user do %>
              <.link
                navigate={~p"/admin/dashboard"}
                class="text-sm font-medium text-base-content/80 hover:text-primary transition-colors"
              >
                {@current_scope.user.email}
              </.link>
              <.link
                method="delete"
                href={~p"/admin/log-out"}
                class="text-sm font-medium text-base-content/80 hover:text-primary transition-colors"
              >
                {gettext("Log out")}
              </.link>
            <% else %>
              <.link
                navigate={~p"/admin"}
                class="text-sm font-medium text-base-content/80 hover:text-primary transition-colors"
              >
                {gettext("Log in")}
              </.link>
              <a href="#contact" class="btn btn-primary btn-sm font-medium px-6">
                {gettext("Get Started")}
              </a>
            <% end %>
          </div>
          
    <!-- Mobile Menu Button -->
          <div class="flex items-center md:hidden gap-4">
            <label for="mobile-drawer" class="btn btn-square btn-ghost">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                class="inline-block w-6 h-6 stroke-current"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M4 6h16M4 12h16M4 18h16"
                >
                </path>
              </svg>
            </label>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def footer(assigns) do
    ~H"""
    <footer class="bg-base-100 border-t border-base-200 pt-16 pb-12">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-2 md:grid-cols-4 gap-8 mb-12">
          <div class="col-span-2 md:col-span-1">
            <.logo />
            <p class="mt-4 text-sm text-base-content/60">
              {gettext(
                "Your strategic engineering partner for scaling high-performance technical teams."
              )}
            </p>
          </div>

          <.footer_group title={gettext("Services")}>
            <.footer_link href="#services">{gettext("Outsourcing")}</.footer_link>
            <.footer_link href="#services">{gettext("Consulting")}</.footer_link>
            <.footer_link href="#services">{gettext("Diagnostics")}</.footer_link>
          </.footer_group>

          <.footer_group title={gettext("Company")}>
            <.footer_link href="#">{gettext("About Us")}</.footer_link>
            <.footer_link href="#contact">{gettext("Contact")}</.footer_link>
          </.footer_group>

          <div>
            <h3 class="text-sm font-semibold text-base-content tracking-wider uppercase mb-4">
              {gettext("Connect")}
            </h3>
            <div class="flex space-x-4">
              <.social_link href="#" icon="hero-link" label={gettext("GitHub")}>
                <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                  <path
                    fill-rule="evenodd"
                    d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
                    clip-rule="evenodd"
                  />
                </svg>
              </.social_link>
              <.social_link href="#" icon="hero-link" label={gettext("LinkedIn")}>
                <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                  <path
                    fill-rule="evenodd"
                    d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"
                    clip-rule="evenodd"
                  />
                </svg>
              </.social_link>
            </div>
          </div>
        </div>

        <div class="border-t border-base-200 pt-8 flex flex-col md:flex-row justify-between items-center gap-4">
          <p class="text-sm text-base-content/40">
            &copy; {Date.utc_today().year} TremTec. {gettext("All rights reserved")}.
          </p>
          <div class="flex space-x-6">
            <a href="#" class="text-sm text-base-content/40 hover:text-base-content">
              {gettext("Privacy Policy")}
            </a>
            <a href="#" class="text-sm text-base-content/40 hover:text-base-content">
              {gettext("Terms of Service")}
            </a>
          </div>
        </div>
      </div>
    </footer>
    """
  end

  defp nav_links do
    [
      %{label: gettext("Services"), href: "#services"},
      %{label: gettext("Methodology"), href: "#methodology"},
      %{label: gettext("About"), href: "#about"}
    ]
  end

  attr :title, :string, required: true
  slot :inner_block, required: true

  defp footer_group(assigns) do
    ~H"""
    <div>
      <h3 class="text-sm font-semibold text-base-content tracking-wider uppercase mb-4">
        {@title}
      </h3>
      <ul class="space-y-3">
        {render_slot(@inner_block)}
      </ul>
    </div>
    """
  end

  attr :href, :string, required: true
  slot :inner_block, required: true

  defp footer_link(assigns) do
    ~H"""
    <li>
      <a href={@href} class="text-sm text-base-content/60 hover:text-primary transition-colors">
        {render_slot(@inner_block)}
      </a>
    </li>
    """
  end

  attr :href, :string, required: true
  attr :label, :string, required: true
  attr :icon, :string, default: nil
  slot :inner_block

  defp social_link(assigns) do
    ~H"""
    <a href={@href} class="text-base-content/40 hover:text-primary transition-colors">
      <span class="sr-only">{@label}</span>
      <%= if @inner_block != [] do %>
        {render_slot(@inner_block)}
      <% else %>
        <.icon name={@icon} class="h-6 w-6" />
      <% end %>
    </a>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100 mx-auto" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100 mx-auto" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100 mx-auto" />
      </button>
    </div>
    """
  end
end
