defmodule TremtecWeb.PublicPages.HomeLiveTest do
  use TremtecWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  use Gettext, backend: TremtecWeb.Gettext

  test "GET / renders landing page", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/")
    assert html =~ gettext("hero title")
  end
end
