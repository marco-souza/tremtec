defmodule TremtecWeb.PageController do
  use TremtecWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def landing_page(conn, _params) do
    render(conn, :landing_page)
  end
end
