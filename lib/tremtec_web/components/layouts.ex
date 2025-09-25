defmodule TremtecWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use TremtecWeb, :html

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

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div class="bg-base-100 drawer">
      <input id="my-drawer-3" type="checkbox" class="drawer-toggle" />

      <div class="drawer-content flex flex-col min-h-screen">
        <.navbar current_scope={@current_scope} />

        <main class="flex-grow">
          {render_slot(@inner_block)}
        </main>

        <.footer />
      </div>

      <.drawer />
    </div>

    <.flash_group flash={@flash} />
    """
  end

  def logo(assigns) do
    ~H"""
    <a href="/" class="flex items-center gap-2">
      <img src={~p"/images/logo.png"} width="48" alt="TremTec logo" />
      <span class="text-lg font-bold">TremTec</span>
    </a>
    """
  end

  def drawer(assigns) do
    ~H"""
    <div class="drawer-side">
      <label for="my-drawer-3" class="drawer-overlay"></label>
      <ul class="menu p-4 w-80 min-h-full bg-base-200">
        <div class="spacer mt-24" />
        <li><.logo /></li>
        <div class="spacer flex-1" />
        <li><.theme_toggle /></li>
      </ul>
    </div>
    """
  end

  def navbar(assigns) do
    ~H"""
    <div class="navbar none sticky top-0 p-4 z-50">
      <div class="flex bg-opacity-80 backdrop-blur-sm shadow-md rounded-lg w-full py-2 px-4 z-50">
        <div class="flex-none lg:hidden">
          <label for="my-drawer-3" class="btn btn-square btn-ghost">
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

        <div class="flex flex-1 mr-12 justify-center lg:justify-start">
          <.logo />
        </div>

        <div class="flex-none hidden lg:block">
          <ul class="menu menu-horizontal gap-4">
            <.theme_toggle />

            <li>
              <a href="#act-now" class="btn btn-primary">
                {gettext("get started")} <span aria-hidden="true">&rarr;</span>
              </a>
            </li>
          </ul>
        </div>
      </div>
    </div>
    """
  end

  def footer(assigns) do
    ~H"""
    <footer class="footer footer-center p-6 bg-base-200 text-base-content">
      <div>
        <p>Copyright © {Date.utc_today().year} - Todos os direitos reservados a TremTec</p>
      </div>
    </footer>
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
