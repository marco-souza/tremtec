defmodule TremtecWeb.PageController do
  use TremtecWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
