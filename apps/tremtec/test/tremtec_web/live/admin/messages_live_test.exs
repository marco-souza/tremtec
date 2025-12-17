defmodule TremtecWeb.Admin.MessagesLiveTest do
  use TremtecWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Index" do
    test "redirects to login if not authenticated", %{conn: conn} do
      {:error, {:redirect, %{to: path}}} = live(conn, ~p"/admin/messages")
      assert path == ~p"/admin/log-in"
    end
  end

  describe "Show" do
    test "redirects to login if not authenticated", %{conn: conn} do
      fake_id = "00000000-0000-0000-0000-000000000000"
      {:error, {:redirect, %{to: path}}} = live(conn, ~p"/admin/messages/#{fake_id}")
      assert path == ~p"/admin/log-in"
    end
  end
end
