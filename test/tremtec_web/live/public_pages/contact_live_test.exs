defmodule TremtecWeb.PublicPages.ContactLiveTest do
  use TremtecWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  use Gettext, backend: TremtecWeb.Gettext

  describe "Contact" do
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

      # Errors are from Ecto and might be HTML escaped in the view
      # We use dgettext for Ecto errors
      assert html =~
               Phoenix.HTML.html_escape(dgettext("errors", "can't be blank"))
               |> Phoenix.HTML.safe_to_string()

      assert html =~
               Phoenix.HTML.html_escape(dgettext("errors", "has invalid format"))
               |> Phoenix.HTML.safe_to_string()
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
