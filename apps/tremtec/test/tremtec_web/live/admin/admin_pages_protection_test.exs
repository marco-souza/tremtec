defmodule TremtecWeb.Admin.AdminPagesProtectionTest do
  use TremtecWeb.ConnCase

  import Phoenix.LiveViewTest

  import Tremtec.AccountsFixtures,
    only: [
      user_fixture: 0,
      override_token_authenticated_at: 2
    ]

  use Gettext, backend: TremtecWeb.Gettext

  describe "Admin pages - unauthenticated access" do
    test "/admin/dashboard redirects to login", %{conn: conn} do
      {:error, {:redirect, %{to: path}}} = live(conn, ~p"/admin/dashboard")
      assert path == ~p"/admin/log-in"
    end

    test "/admin/messages redirects to login", %{conn: conn} do
      {:error, {:redirect, %{to: path}}} = live(conn, ~p"/admin/messages")
      assert path == ~p"/admin/log-in"
    end

    test "/admin/messages/:id redirects to login", %{conn: conn} do
      fake_id = "00000000-0000-0000-0000-000000000000"
      {:error, {:redirect, %{to: path}}} = live(conn, ~p"/admin/messages/#{fake_id}")
      assert path == ~p"/admin/log-in"
    end

    test "/admin/users redirects to login", %{conn: conn} do
      {:error, {:redirect, %{to: path}}} = live(conn, ~p"/admin/users")
      assert path == ~p"/admin/log-in"
    end

    test "/admin/settings redirects to login", %{conn: conn} do
      {:error, {:redirect, %{to: path}}} = live(conn, ~p"/admin/settings")
      assert path == ~p"/admin/log-in"
    end
  end

  describe "Admin pages - authenticated access" do
    setup %{conn: conn} do
      user = user_fixture()
      # Create a session with the user token
      user_token = Tremtec.Accounts.generate_user_session_token(user)

      conn =
        conn
        |> init_test_session(%{user_token: user_token})
        |> TremtecWeb.UserAuth.fetch_current_scope_for_user([])

      %{conn: conn, user: user}
    end

    test "authenticated user can access /admin/dashboard", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/admin/dashboard")

      # Verify page loads and contains expected content
      assert html =~ gettext("Admin Dashboard")
    end

    test "authenticated user can access /admin/messages", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/admin/messages")

      assert html =~ gettext("Messages")
    end

    test "authenticated user can access /admin/users", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/admin/users")

      assert html =~ gettext("Users")
    end

    test "authenticated user can access /admin/settings", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/admin/settings")

      assert html =~ gettext("Account Settings")
    end
  end

  describe "POST routes - unauthenticated access" do
    test "POST /admin/update-password requires authentication", %{conn: conn} do
      conn = post(conn, ~p"/admin/update-password", %{"user" => %{"password" => "new_pass"}})

      assert redirected_to(conn) == ~p"/admin/log-in"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) ==
               "You must log in to access this page."
    end
  end

  describe "Settings page - sudo mode protection" do
    test "settings page requires recent authentication (sudo mode)", %{conn: conn} do
      # Create user and then set old authentication timestamp
      user = user_fixture()
      user_token = Tremtec.Accounts.generate_user_session_token(user)

      # Set token authenticated_at to 30 minutes ago (exceeds 20 minute limit)
      old_auth_time = DateTime.utc_now(:second) |> DateTime.add(-30, :minute)
      override_token_authenticated_at(user_token, old_auth_time)

      conn =
        conn
        |> init_test_session(%{user_token: user_token})
        |> TremtecWeb.UserAuth.fetch_current_scope_for_user([])

      # User with old authentication should be redirected to login
      {:error, {:redirect, %{to: path}}} = live(conn, ~p"/admin/settings")

      # Should redirect to login for sudo mode verification
      assert path == ~p"/admin/log-in"
    end

    test "settings page allows access with recent authentication", %{conn: conn} do
      # Create user with fresh token (authenticated less than 20 minutes ago)
      user = user_fixture()
      user_token = Tremtec.Accounts.generate_user_session_token(user)

      conn =
        conn
        |> init_test_session(%{user_token: user_token})
        |> TremtecWeb.UserAuth.fetch_current_scope_for_user([])

      # User with recent authentication should be allowed
      {:ok, _lv, html} = live(conn, ~p"/admin/settings")

      assert html =~ gettext("Account Settings")
    end
  end
end
