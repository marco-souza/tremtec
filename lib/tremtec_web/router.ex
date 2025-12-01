defmodule TremtecWeb.Router do
  use TremtecWeb, :router

  import TremtecWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TremtecWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user

    plug TremtecWeb.Plug.DetermineLocale,
      supported_locales: Tremtec.Config.supported_locales(),
      default_locale: Tremtec.Config.default_locale(),
      gettext: TremtecWeb.Gettext
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/api", TremtecWeb do
    pipe_through :api

    # health check endpoint
    get "/healthz", HealthcheckController, :healthz
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:tremtec, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TremtecWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", TremtecWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{TremtecWeb.UserAuth, :require_authenticated}, TremtecWeb.RestoreLocale] do
      live "/admin/dashboard", Admin.DashboardLive
      live "/admin/settings", UserLive.Settings, :edit
      live "/admin/settings/confirm-email/:token", UserLive.Settings, :confirm_email

      live "/admin/messages", Admin.MessagesLive.IndexLive
      live "/admin/messages/:id", Admin.MessagesLive.ShowLive
      live "/admin/users", Admin.UsersLive.IndexLive
    end

    post "/admin/update-password", UserSessionController, :update_password
  end

  scope "/", TremtecWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{TremtecWeb.UserAuth, :mount_current_scope}, TremtecWeb.RestoreLocale] do
      live "/", PublicPages.HomeLive
      live "/contact", PublicPages.ContactLive

      live "/admin/register", UserLive.Registration, :new
      live "/admin/log-in", UserLive.Login, :new
      live "/admin/log-in/:token", UserLive.Confirmation, :new
    end

    get "/admin", UserSessionController, :admin_redirect
    post "/admin/log-in", UserSessionController, :create
    delete "/admin/log-out", UserSessionController, :delete
  end
end
