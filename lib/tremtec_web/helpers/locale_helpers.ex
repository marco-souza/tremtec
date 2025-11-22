defmodule TremtecWeb.LocaleHelpers do
  @moduledoc """
  Helper functions for accessing locale information throughout the app.
  
  Locale is determined automatically from the Accept-Language header
  and is available in assigns as `:locale`.
  """

  @supported_locales ["pt", "en", "es"]
  @default_locale "pt"

  def supported_locales, do: @supported_locales
  def default_locale, do: @default_locale

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
