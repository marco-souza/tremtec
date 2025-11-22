defmodule TremtecWeb.ContactLiveTest do
  use TremtecWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  use Gettext, backend: TremtecWeb.Gettext

  describe "/contact" do
    test "renders contact form", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/contact")
      assert html =~ "contact-form"
    end

    test "validates in real-time", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/contact")

      html =
        render_change(view, "validate", %{
          "contact" => %{"name" => "", "email" => "bad", "message" => "short"}
        })

      # Check for validation error messages using gettext
      blank_msg = dgettext("errors", "can't be blank")
      invalid_msg = dgettext("errors", "has invalid format")
      # For plural forms, test the beginning of translated message (ngettext handles pluralization)
      min_length_msg = ngettext("You have at least %{count} character", "You have at least %{count} characters", 10, count: 10)

      assert html =~ blank_msg
      assert html =~ invalid_msg
      # Check for the error container instead of exact message due to pluralization
      assert html =~ "phx-feedback-for="
    end

    test "rejects honeypot submissions", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/contact")

      html =
        render_submit(view, "save", %{
          "contact" => %{
            "name" => "Jane",
            "email" => "jane@example.com",
            "message" => String.duplicate("hello world ", 2),
            "nickname" => "bot"
          }
        })

      # Should not show success message for honeypot submissions
      success_msg = gettext("Thanks! Your message has been sent.")
      refute html =~ success_msg
    end

    test "submits successfully and clears the form", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/contact")

      html =
        render_submit(view, "save", %{
          "contact" => %{
            "name" => "Jane",
            "email" => "jane@example.com",
            "message" => String.duplicate("hello world ", 2),
            "nickname" => ""
          }
        })

      success_msg = gettext("Thanks! Your message has been sent.")
      assert html =~ success_msg

      # After success, inputs should be cleared
      refute html =~ "jane@example.com"
    end
  end
end
