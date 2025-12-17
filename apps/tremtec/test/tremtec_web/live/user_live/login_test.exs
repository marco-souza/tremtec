defmodule TremtecWeb.UserLive.LoginTest do
  use TremtecWeb.ConnCase

  import Phoenix.LiveViewTest
  import Tremtec.AccountsFixtures
  use Gettext, backend: TremtecWeb.Gettext

  describe "login page" do
    test "renders login page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/admin/log-in")

      assert html =~ gettext("Log in")
      assert html =~ gettext("Sign up")
      assert html =~ gettext("Log in with email")
    end
  end

  describe "user login - magic link" do
    test "sends magic link email when user exists", %{conn: conn} do
      user = user_fixture()

      {:ok, lv, _html} = live(conn, ~p"/admin/log-in")

      {:ok, _lv, html} =
        form(lv, "#login_form_magic", user: %{email: user.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/log-in")

      assert html =~ gettext("If your email is in our system")

      assert Tremtec.Repo.get_by!(Tremtec.Accounts.UserToken, user_id: user.id).context ==
               "login"
    end

    test "does not disclose if user is registered", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/admin/log-in")

      {:ok, _lv, html} =
        form(lv, "#login_form_magic", user: %{email: "idonotexist@example.com"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/log-in")

      assert html =~ gettext("If your email is in our system")
    end
  end

  describe "user login - password" do
    test "redirects if user logs in with valid credentials", %{conn: conn} do
      user = user_fixture() |> set_password()

      {:ok, lv, _html} = live(conn, ~p"/admin/log-in")

      form =
        form(lv, "#login_form_password",
          user: %{email: user.email, password: valid_user_password(), remember_me: true}
        )

      conn = submit_form(form, conn)

      assert redirected_to(conn) == ~p"/"
    end

    test "redirects to login page with a flash error if credentials are invalid", %{
      conn: conn
    } do
      {:ok, lv, _html} = live(conn, ~p"/admin/log-in")

      form =
        form(lv, "#login_form_password", user: %{email: "test@email.com", password: "123456"})

      render_submit(form, %{user: %{remember_me: true}})

      conn = follow_trigger_action(form, conn)
      assert Phoenix.Flash.get(conn.assigns.flash, :error) == gettext("Invalid email or password")
      assert redirected_to(conn) == ~p"/admin/log-in"
    end
  end

  describe "login navigation" do
    test "redirects to registration page when the Register button is clicked", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/admin/log-in")

      {:ok, _login_live, login_html} =
        lv
        |> element("main a", gettext("Sign up"))
        |> render_click()
        |> follow_redirect(conn, ~p"/admin/register")

      assert login_html =~ gettext("Register")
    end
  end

  describe "re-authentication (sudo mode)" do
    setup %{conn: conn} do
      user = user_fixture()
      %{user: user, conn: log_in_user(conn, user)}
    end

    test "shows login page with email filled in", %{conn: conn, user: user} do
      {:ok, _lv, html} = live(conn, ~p"/admin/log-in")

      assert html =~
               gettext("You need to reauthenticate to perform sensitive actions on your account.")

      refute html =~ gettext("Register")
      assert html =~ gettext("Log in with email")

      assert html =~
               ~s(<input type="email" name="user[email]" id="login_form_magic_email" value="#{user.email}")
    end
  end
end
