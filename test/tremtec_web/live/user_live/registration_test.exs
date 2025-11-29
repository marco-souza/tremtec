defmodule TremtecWeb.UserLive.RegistrationTest do
  use TremtecWeb.ConnCase

  import Phoenix.LiveViewTest
  import Tremtec.AccountsFixtures
  use Gettext, backend: TremtecWeb.Gettext

  describe "Registration page" do
    test "renders registration page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/admin/register")

      assert html =~ gettext("Register")
      assert html =~ gettext("Log in")
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/admin/register")
        |> follow_redirect(conn, ~p"/")

      assert {:ok, _conn} = result
    end

    test "renders errors for invalid data", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/admin/register")

      result =
        lv
        |> element("#registration_form")
        |> render_change(user: %{"email" => "with spaces"})

      assert result =~ gettext("Register")

      assert result =~
               Phoenix.HTML.html_escape(dgettext("errors", "must have the @ sign and no spaces"))
               |> Phoenix.HTML.safe_to_string()
    end
  end

  describe "register user" do
    test "creates account but does not log in", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/admin/register")

      email = unique_user_email()
      form = form(lv, "#registration_form", user: valid_user_attributes(email: email))

      {:ok, _lv, html} =
        render_submit(form)
        |> follow_redirect(conn, ~p"/admin/log-in")

      assert html =~
               gettext("An email was sent to %{email}, please access it to confirm your account",
                 email: email
               )
    end

    test "renders errors for duplicated email", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/admin/register")

      user = user_fixture(%{email: "test@example.com"})

      result =
        lv
        |> form("#registration_form",
          user: %{"email" => user.email}
        )
        |> render_submit()

      assert result =~
               Phoenix.HTML.html_escape(dgettext("errors", "has already been taken"))
               |> Phoenix.HTML.safe_to_string()
    end
  end

  describe "registration navigation" do
    test "redirects to login page when the Log in button is clicked", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/admin/register")

      {:ok, _login_live, login_html} =
        lv
        |> element("main a", gettext("Log in"))
        |> render_click()
        |> follow_redirect(conn, ~p"/admin/log-in")

      assert login_html =~ gettext("Log in")
    end
  end
end
