defmodule TremtecWeb.LandingLiveTest do
  use TremtecWeb.ConnCase

  import Phoenix.LiveViewTest

  test "GET /", %{conn: conn} do
    {:ok, _index_live, html} = live(conn, ~p"/")
    assert html =~ "TremTec"
  end
end
