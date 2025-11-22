defmodule TremtecWeb.LocaleHelpersTest do
  use TremtecWeb.ConnCase

  import Plug.Conn

  alias TremtecWeb.LocaleHelpers

  setup do
    # Build a connection that can handle sessions
    conn =
      build_conn()
      |> init_test_session(%{})

    {:ok, conn: conn}
  end

  describe "get_locale/1 with Plug.Conn" do
    test "returns locale from session", %{conn: conn} do
      conn = put_session(conn, :locale, "en")
      assert LocaleHelpers.get_locale(conn) == "en"
    end

    test "returns default locale when session is empty", %{conn: conn} do
      conn = put_session(conn, :locale, nil)
      assert LocaleHelpers.get_locale(conn) == Tremtec.Config.default_locale()
    end

    test "returns default locale when session key doesn't exist", %{conn: conn} do
      assert LocaleHelpers.get_locale(conn) == Tremtec.Config.default_locale()
    end

    test "returns default locale for invalid session value", %{conn: conn} do
      # Store an invalid value (not a binary)
      conn = put_session(conn, :locale, :invalid_atom)
      assert LocaleHelpers.get_locale(conn) == Tremtec.Config.default_locale()
    end

    test "returns Portuguese (default) for integer value in session", %{conn: conn} do
      conn = put_session(conn, :locale, 123)
      assert LocaleHelpers.get_locale(conn) == "pt"
    end

    test "returns Portuguese (default) for empty list in session", %{conn: conn} do
      conn = put_session(conn, :locale, [])
      assert LocaleHelpers.get_locale(conn) == "pt"
    end

    test "respects different valid locales", %{conn: conn} do
      assert LocaleHelpers.get_locale(put_session(conn, :locale, "pt")) == "pt"
      assert LocaleHelpers.get_locale(put_session(conn, :locale, "en")) == "en"
      assert LocaleHelpers.get_locale(put_session(conn, :locale, "es")) == "es"
    end
  end

  describe "get_locale/1 with Phoenix.LiveView.Socket" do
    test "returns locale from socket assigns" do
      # Create a mock socket with locale assign
      socket = %Phoenix.LiveView.Socket{
        assigns: %{locale: "en"}
      }

      assert LocaleHelpers.get_locale(socket) == "en"
    end

    test "returns default locale when assign is nil" do
      socket = %Phoenix.LiveView.Socket{
        assigns: %{locale: nil}
      }

      assert LocaleHelpers.get_locale(socket) == Tremtec.Config.default_locale()
    end

    test "returns default locale when assign doesn't exist" do
      socket = %Phoenix.LiveView.Socket{
        assigns: %{}
      }

      assert LocaleHelpers.get_locale(socket) == Tremtec.Config.default_locale()
    end

    test "returns default locale for invalid socket assign value" do
      socket = %Phoenix.LiveView.Socket{
        assigns: %{locale: :invalid_atom}
      }

      assert LocaleHelpers.get_locale(socket) == Tremtec.Config.default_locale()
    end

    test "respects different valid locales in socket" do
      assert LocaleHelpers.get_locale(%Phoenix.LiveView.Socket{assigns: %{locale: "pt"}}) == "pt"
      assert LocaleHelpers.get_locale(%Phoenix.LiveView.Socket{assigns: %{locale: "en"}}) == "en"
      assert LocaleHelpers.get_locale(%Phoenix.LiveView.Socket{assigns: %{locale: "es"}}) == "es"
    end
  end

  describe "get_locale/1 with other types" do
    test "returns default locale for any other type" do
      assert LocaleHelpers.get_locale(nil) == Tremtec.Config.default_locale()
      assert LocaleHelpers.get_locale("string") == Tremtec.Config.default_locale()
      assert LocaleHelpers.get_locale(123) == Tremtec.Config.default_locale()
      assert LocaleHelpers.get_locale([]) == Tremtec.Config.default_locale()
      assert LocaleHelpers.get_locale(%{}) == Tremtec.Config.default_locale()
    end
  end

  describe "is_supported_locale?/1" do
    test "returns true for supported locales" do
      assert LocaleHelpers.is_supported_locale?("pt") == true
      assert LocaleHelpers.is_supported_locale?("en") == true
      assert LocaleHelpers.is_supported_locale?("es") == true
    end

    test "returns false for unsupported locales" do
      assert LocaleHelpers.is_supported_locale?("fr") == false
      assert LocaleHelpers.is_supported_locale?("de") == false
      assert LocaleHelpers.is_supported_locale?("ja") == false
      assert LocaleHelpers.is_supported_locale?("pt-BR") == false
      assert LocaleHelpers.is_supported_locale?("en-US") == false
    end

    test "returns false for invalid types" do
      assert LocaleHelpers.is_supported_locale?(nil) == false
      assert LocaleHelpers.is_supported_locale?(123) == false
      assert LocaleHelpers.is_supported_locale?([]) == false
      assert LocaleHelpers.is_supported_locale?(%{}) == false
    end

    test "returns false for empty string" do
      assert LocaleHelpers.is_supported_locale?("") == false
    end

    test "returns false for case-sensitive mismatch" do
      assert LocaleHelpers.is_supported_locale?("PT") == false
      assert LocaleHelpers.is_supported_locale?("En") == false
      assert LocaleHelpers.is_supported_locale?("ES") == false
    end
  end

  describe "language_name/1" do
    test "returns Portuguese name for pt" do
      assert LocaleHelpers.language_name("pt") == "Português"
    end

    test "returns English name for en" do
      assert LocaleHelpers.language_name("en") == "English"
    end

    test "returns Spanish name for es" do
      assert LocaleHelpers.language_name("es") == "Español"
    end

    test "returns default locale string for unknown locale" do
      assert LocaleHelpers.language_name("fr") == Tremtec.Config.default_locale()
      assert LocaleHelpers.language_name("de") == Tremtec.Config.default_locale()
      assert LocaleHelpers.language_name("") == Tremtec.Config.default_locale()
    end

    test "returns default locale string for invalid types" do
      assert LocaleHelpers.language_name(nil) == Tremtec.Config.default_locale()
      assert LocaleHelpers.language_name(123) == Tremtec.Config.default_locale()
    end
  end
end
