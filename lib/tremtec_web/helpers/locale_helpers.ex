defmodule TremtecWeb.LocaleHelpers do
  @moduledoc """
  Helper functions for managing locale/language preferences throughout the app.
  """

  import Plug.Conn

  @supported_locales ["pt", "en", "es"]
  @default_locale "pt"
  @locale_cookie_key "preferred_locale"

  def supported_locales, do: @supported_locales
  def default_locale, do: @default_locale
  def locale_cookie_key, do: @locale_cookie_key

  @doc """
  Get the current locale from connection/socket assigns.
  Falls back to default locale if not set.
  """
  def get_locale(conn_or_socket)

  def get_locale(%Plug.Conn{} = conn) do
    Plug.Conn.get_session(conn, :locale) || @default_locale
  end

  def get_locale(%Phoenix.LiveView.Socket{} = socket) do
    socket.assigns[:locale] || @default_locale
  end

  def get_locale(_), do: @default_locale

  @doc """
  Set the user's preferred locale by updating session and setting cookie.
  """
  def set_locale(conn, locale) when locale in @supported_locales do
    conn
    |> put_session(@locale_cookie_key, locale)
    |> put_resp_cookie(@locale_cookie_key, locale, max_age: 365 * 24 * 60 * 60)
  end

  def set_locale(conn, _locale), do: conn

  @doc """
  Check if a locale is supported.
  """
  def is_supported_locale?(locale) do
    locale in @supported_locales
  end

  @doc """
  Get the language name for display purposes.
  """
  def language_name(locale) do
    case locale do
      "pt" -> "Português"
      "en" -> "English"
      "es" -> "Español"
      _ -> @default_locale
    end
  end
end
