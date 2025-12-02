defmodule TremtecWeb.UserLive.SettingsTest do
  use TremtecWeb.ConnCase

  alias Tremtec.Accounts
  import Phoenix.LiveViewTest
  import Tremtec.AccountsFixtures
  use Gettext, backend: TremtecWeb.Gettext

  describe "Settings page" do
    test "renders settings page", %{conn: conn} do
      {:ok, _lv, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/admin/settings")

      assert html =~ gettext("Change Email")
      assert html =~ gettext("Save Password")
    end

    test "redirects if user is not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/admin/settings")

      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/admin/log-in"
      assert %{"error" => message} = flash
      assert message == gettext("You must log in to access this page.")
    end

    test "redirects if user is not in sudo mode", %{conn: conn} do
      {:ok, conn} =
        conn
        |> log_in_user(user_fixture(),
          token_authenticated_at: DateTime.add(DateTime.utc_now(:second), -11, :minute)
        )
        |> live(~p"/admin/settings")
        |> follow_redirect(conn, ~p"/admin/log-in")

      assert conn.resp_body =~ gettext("You must re-authenticate to access this page.")
    end
  end

  describe "update email form" do
    setup %{conn: conn} do
      user = user_fixture()
      %{conn: log_in_user(conn, user), user: user}
    end

    test "updates the user email", %{conn: conn, user: user} do
      new_email = unique_user_email()

      {:ok, lv, _html} = live(conn, ~p"/admin/settings")

      result =
        lv
        |> form("#email_form", %{
          "user" => %{"email" => new_email}
        })
        |> render_submit()

      assert result =~
               gettext("A link to confirm your email change has been sent to the new address.")

      assert Accounts.get_user_by_email(user.email)
    end

    test "renders errors with invalid data (phx-change)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/admin/settings")

      result =
        lv
        |> element("#email_form")
        |> render_change(%{
          "action" => "update_email",
          "user" => %{"email" => "with spaces"}
        })

      assert result =~ gettext("Change Email")

      assert result =~
               Phoenix.HTML.html_escape(dgettext("errors", "must have the @ sign and no spaces"))
               |> Phoenix.HTML.safe_to_string()
    end

    test "renders errors with invalid data (phx-submit)", %{conn: conn, user: user} do
      {:ok, lv, _html} = live(conn, ~p"/admin/settings")

      result =
        lv
        |> form("#email_form", %{
          "user" => %{"email" => user.email}
        })
        |> render_submit()

      assert result =~ gettext("Change Email")

      assert result =~
               Phoenix.HTML.html_escape(dgettext("errors", "did not change"))
               |> Phoenix.HTML.safe_to_string()
    end
  end

  describe "update password form" do
    setup %{conn: conn} do
      user = user_fixture()
      %{conn: log_in_user(conn, user), user: user}
    end

    test "updates the user password", %{conn: conn, user: user} do
      new_password = valid_user_password()

      {:ok, lv, _html} = live(conn, ~p"/admin/settings")

      form =
        form(lv, "#password_form", %{
          "user" => %{
            "email" => user.email,
            "password" => new_password,
            "password_confirmation" => new_password
          }
        })

      render_submit(form)

      new_password_conn = follow_trigger_action(form, conn)

      assert redirected_to(new_password_conn) == ~p"/admin/settings"

      assert get_session(new_password_conn, :user_token) != get_session(conn, :user_token)

      assert Phoenix.Flash.get(new_password_conn.assigns.flash, :info) =~
               gettext("Password updated successfully!")

      assert Accounts.get_user_by_email_and_password(user.email, new_password)
    end

    test "renders errors with invalid data (phx-change)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/admin/settings")

      result =
        lv
        |> element("#password_form")
        |> render_change(%{
          "user" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      assert result =~ gettext("Save Password")

      assert result =~
               Phoenix.HTML.html_escape(
                 dgettext("errors", "should be at least %{count} character(s)", count: 12)
               )
               |> Phoenix.HTML.safe_to_string()

      assert result =~
               Phoenix.HTML.html_escape(dgettext("errors", "does not match password"))
               |> Phoenix.HTML.safe_to_string()
    end

    test "renders errors with invalid data (phx-submit)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/admin/settings")

      result =
        lv
        |> form("#password_form", %{
          "user" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })
        |> render_submit()

      assert result =~ gettext("Save Password")

      assert result =~
               Phoenix.HTML.html_escape(
                 dgettext("errors", "should be at least %{count} character(s)", count: 12)
               )
               |> Phoenix.HTML.safe_to_string()

      assert result =~
               Phoenix.HTML.html_escape(dgettext("errors", "does not match password"))
               |> Phoenix.HTML.safe_to_string()
    end
  end

  describe "confirm email" do
    setup %{conn: conn} do
      user = user_fixture()
      email = unique_user_email()

      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_update_email_instructions(%{user | email: email}, user.email, url)
        end)

      %{conn: log_in_user(conn, user), token: token, email: email, user: user}
    end

    test "updates the user email once", %{conn: conn, user: user, token: token, email: email} do
      {:error, redirect} = live(conn, ~p"/admin/settings/confirm-email/#{token}")

      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/admin/settings"
      assert %{"info" => message} = flash
      assert message == gettext("Email changed successfully.")
      refute Accounts.get_user_by_email(user.email)
      assert Accounts.get_user_by_email(email)

      # use confirm token again
      {:error, redirect} = live(conn, ~p"/admin/settings/confirm-email/#{token}")
      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/admin/settings"
      assert %{"error" => message} = flash
      assert message == gettext("Email change link is invalid or it has expired.")
    end

    test "does not update email with invalid token", %{conn: conn, user: user} do
      {:error, redirect} = live(conn, ~p"/admin/settings/confirm-email/oops")
      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/admin/settings"
      assert %{"error" => message} = flash
      assert message == gettext("Email change link is invalid or it has expired.")
      assert Accounts.get_user_by_email(user.email)
    end

    test "redirects if user is not logged in", %{token: token} do
      conn = build_conn()
      {:error, redirect} = live(conn, ~p"/admin/settings/confirm-email/#{token}")
      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/admin/log-in"
      assert %{"error" => message} = flash
      assert message == gettext("You must log in to access this page.")
    end
  end
end
