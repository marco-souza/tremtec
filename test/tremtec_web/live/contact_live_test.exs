defmodule TremtecWeb.ContactLiveTest do
  use TremtecWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "/:locale/contact" do
    test "renders contact form", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/en/contact")
      assert html =~ "contact-form"
    end

    test "validates in real-time", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/en/contact")

      html =
        render_change(view, "validate", %{
          "contact" => %{"name" => "", "email" => "bad", "message" => "short"}
        })

      assert html =~ "can&#39;t be blank"
      assert html =~ "has invalid format"
      assert html =~ "should be at least"
    end

    test "rejects honeypot submissions", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/en/contact")

      html =
        render_submit(view, "save", %{
          "contact" => %{
            "name" => "Jane",
            "email" => "jane@example.com",
            "message" => String.duplicate("hello world ", 2),
            "nickname" => "bot"
          }
        })

      assert html =~ "Spam detected"
    end

    test "submits successfully and clears the form", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/en/contact")

      html =
        render_submit(view, "save", %{
          "contact" => %{
            "name" => "Jane",
            "email" => "jane@example.com",
            "message" => String.duplicate("hello world ", 2),
            "nickname" => ""
          }
        })

      assert html =~ "Thanks! Your message has been sent."

      # After success, inputs should be cleared
      refute html =~ "jane@example.com"
    end
  end
end
