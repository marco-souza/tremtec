defmodule TremtecWeb.PublicPages.ContactLiveTest do
  use TremtecWeb.ConnCase, async: false

  import Phoenix.LiveViewTest
  use Gettext, backend: TremtecWeb.Gettext

  setup do
    # Reset any stubs between tests
    :ok
  end

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

    test "rejects submission when CAPTCHA token is missing", %{conn: conn} do
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

      # Should show CAPTCHA error
      error_msg = gettext("Verification failed. Please try again.")
      assert html =~ error_msg
    end

    @tag :external
    test "rejects submission when CAPTCHA token is invalid", %{conn: conn} do
      # This test requires actual HTTP call to Cloudflare API
      # Tagged as external - run with mix test --include external
      # Skip by default with mix test

      {:ok, view, _html} = live(conn, ~p"/contact")

      html =
        render_submit(view, "save", %{
          "contact" => %{
            "name" => "Jane",
            "email" => "jane@example.com",
            "message" => String.duplicate("hello world ", 2),
            "nickname" => ""
          },
          "cf-turnstile-response" => "invalid-token"
        })

      # With an invalid token, the Cloudflare API will return success: false
      # This is expected behavior - the test verifies the form handles it
      error_msg = gettext("Verification failed. Please try again.")
      assert html =~ error_msg
    end
  end
end
