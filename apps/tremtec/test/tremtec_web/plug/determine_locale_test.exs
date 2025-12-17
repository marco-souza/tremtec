defmodule TremtecWeb.Plug.DetermineLocaleTest do
  use TremtecWeb.ConnCase

  import Plug.Conn

  setup do
    opts = [
      supported_locales: Tremtec.Config.supported_locales(),
      default_locale: Tremtec.Config.default_locale(),
      gettext: TremtecWeb.Gettext
    ]

    {:ok, opts: opts}
  end

  defp conn_with_session() do
    build_conn() |> init_test_session(%{})
  end

  describe "locale detection from Accept-Language header" do
    test "detects Portuguese from simple pt header", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "pt")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      assert conn.assigns[:locale] == "pt"
      assert get_session(conn, :locale) == "pt"
    end

    test "detects Portuguese from pt-BR variant", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "pt-BR")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      assert conn.assigns[:locale] == "pt"
      assert get_session(conn, :locale) == "pt"
    end

    test "detects Portuguese from pt-PT variant", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "pt-PT")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      assert conn.assigns[:locale] == "pt"
      assert get_session(conn, :locale) == "pt"
    end

    test "detects English from en-US variant", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "en-US")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      assert conn.assigns[:locale] == "en"
      assert get_session(conn, :locale) == "en"
    end

    test "detects Spanish from es-ES variant", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "es-ES")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      assert conn.assigns[:locale] == "es"
      assert get_session(conn, :locale) == "es"
    end

    test "detects Spanish from es-MX variant", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "es-MX")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      assert conn.assigns[:locale] == "es"
      assert get_session(conn, :locale) == "es"
    end
  end

  describe "quality factor (q value) handling" do
    test "respects quality factor preference", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "en;q=0.5,pt;q=0.9")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      # Portuguese has higher quality (0.9), so should be selected
      assert conn.assigns[:locale] == "pt"
    end

    test "prefers higher quality value over order", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "es;q=0.1,pt;q=0.5,en;q=0.9")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      # English has highest quality (0.9)
      assert conn.assigns[:locale] == "en"
    end

    test "handles default quality (1.0) correctly", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "pt,en;q=0.8")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      # Portuguese has implicit quality of 1.0, higher than en (0.8)
      assert conn.assigns[:locale] == "pt"
    end

    test "handles malformed quality values", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "pt;q=invalid,en;q=0.5")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      # Malformed quality should default to 1.0
      assert conn.assigns[:locale] == "pt"
    end
  end

  describe "fallback to default locale" do
    test "uses default locale when no Accept-Language header", %{opts: opts} do
      conn =
        conn_with_session()
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      assert conn.assigns[:locale] == "en"
      assert get_session(conn, :locale) == "en"
    end

    test "uses default locale for unsupported languages", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "fr,de;q=0.9")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      # French and German are not supported, should fall back to English
      assert conn.assigns[:locale] == "en"
    end

    test "uses default locale when only unsupported variants are provided", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "fr-FR,de-DE;q=0.9")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      # Unsupported languages, should fall back to English
      assert conn.assigns[:locale] == "en"
    end

    test "ignores unsupported languages and selects from supported ones", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "fr;q=0.9,pt;q=0.8,de;q=0.7")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      # Only pt is supported from the list, should select it
      assert conn.assigns[:locale] == "pt"
    end
  end

  describe "complex Accept-Language header scenarios" do
    test "handles comma-separated list with variants", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "pt-BR,pt;q=0.9,en;q=0.8")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      # pt-BR is highest quality (implicit 1.0)
      assert conn.assigns[:locale] == "pt"
    end

    test "handles whitespace in header", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "  pt  ,  en;q=0.5  ")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      assert conn.assigns[:locale] == "pt"
    end

    test "handles complex header with multiple preferences", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "pt-BR,en;q=0.5")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      # pt-BR has highest quality (implicit 1.0), en has 0.5
      assert conn.assigns[:locale] == "pt"
    end

    test "handles empty header gracefully", %{opts: opts} do
      conn =
        conn_with_session()
        |> put_req_header("accept-language", "")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      assert conn.assigns[:locale] == "en"
    end
  end

  describe "Gettext locale configuration" do
    test "sets Gettext locale correctly", %{opts: opts} do
      _conn =
        conn_with_session()
        |> put_req_header("accept-language", "en")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      # Gettext should be set to "en"
      assert Gettext.get_locale(TremtecWeb.Gettext) == "en"
    end

    test "resets Gettext locale for each request", %{opts: opts} do
      # First request sets locale to "pt"
      _conn1 =
        conn_with_session()
        |> put_req_header("accept-language", "pt")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      assert Gettext.get_locale(TremtecWeb.Gettext) == "pt"

      # Second request sets locale to "en"
      _conn2 =
        conn_with_session()
        |> put_req_header("accept-language", "en")
        |> TremtecWeb.Plug.DetermineLocale.call(opts)

      assert Gettext.get_locale(TremtecWeb.Gettext) == "en"
    end
  end
end
