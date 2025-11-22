defmodule TremtecWeb.PageControllerTest do
  use TremtecWeb.ConnCase

  test "GET / renders landing page", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "TremTec"
  end
end
