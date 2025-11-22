defmodule TremtecWeb.Plug.DetermineLocale do
  @moduledoc """
  Plug to determine user's locale based on:
  1. Preferred locale cookie (if set)
  2. Accept-Language header (if available)
  3. Default locale (pt)

  The determined locale is set in the session and made available to Gettext.
  """

  import Plug.Conn

  require Logger

  def init(opts) do
    [
      cookie_key: Keyword.get(opts, :cookie_key, "preferred_locale"),
      supported_locales: Keyword.get(opts, :supported_locales, ["pt", "en"]),
      default_locale: Keyword.get(opts, :default_locale, "pt"),
      gettext: Keyword.get(opts, :gettext, TremtecWeb.Gettext)
    ]
  end

  def call(conn, opts) do
    locale = determine_locale(conn, opts)

    Gettext.put_locale(opts[:gettext], locale)

    conn
    |> put_session(:locale, locale)
    |> assign(:locale, locale)
  end

  defp determine_locale(conn, opts) do
    # Try to get from cookie first
    case get_session(conn, opts[:cookie_key]) do
      nil ->
        # Fall back to Accept-Language header
        parse_accept_language(
          get_req_header(conn, "accept-language"),
          opts[:supported_locales],
          opts[:default_locale]
        )

      locale ->
        Logger.info("Using locale from cookie: #{locale}")
        locale
    end
  end

  defp parse_accept_language([], _supported_locales, default_locale), do: default_locale

  defp parse_accept_language(headers, supported_locales, default_locale) do
    accept_language = Enum.join(headers, ",")

    accept_language
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_language_tag/1)
    |> Enum.sort_by(fn {_lang, quality} -> quality end, :desc)
    |> Enum.find_value(default_locale, fn {lang, _quality} ->
      if lang in supported_locales do
        Logger.info("Using locale from Accept-Language header: #{lang}")
        lang
      else
        nil
      end
    end)
  end

  defp parse_language_tag(tag) do
    case String.split(tag, ";q=") do
      [lang] ->
        {String.trim(lang), 1.0}

      [lang, quality] ->
        case Float.parse(String.trim(quality)) do
          {q, _} -> {String.trim(lang), q}
          :error -> {String.trim(lang), 1.0}
        end

      _ ->
        {String.trim(tag), 0.0}
    end
  end
end
