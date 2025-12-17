defmodule TremtecWeb.Plug.DetermineLocale do
  @moduledoc """
  Plug to determine user's locale based on:
  1. Accept-Language header (if available)
  2. Default locale (pt)

  The determined locale is set in the session and made available to Gettext.
  """

  import Plug.Conn

  require Logger

  def init(opts) do
    [
      supported_locales: Keyword.get(opts, :supported_locales, ["pt", "en", "es"]),
      default_locale: Keyword.get(opts, :default_locale, "pt"),
      gettext: Keyword.get(opts, :gettext, TremtecWeb.Gettext)
    ]
  end

  def call(conn, opts) do
    locale =
      parse_accept_language(
        get_req_header(conn, "accept-language"),
        opts[:supported_locales],
        opts[:default_locale]
      )

    Gettext.put_locale(opts[:gettext], locale)

    conn
    |> put_session(:locale, locale)
    |> assign(:locale, locale)
  end

  defp parse_accept_language([], _supported_locales, default_locale), do: default_locale

  defp parse_accept_language(headers, supported_locales, default_locale) do
    accept_language = Enum.join(headers, ",")

    parsed_languages =
      accept_language
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&parse_language_tag/1)
      |> Enum.sort_by(fn {_lang, quality} -> quality end, :desc)

    case Enum.find(parsed_languages, fn {lang, _} -> lang in supported_locales end) do
      {lang, _} ->
        if Application.get_env(:tremtec, :dev_routes) do
          Logger.info("Using locale from Accept-Language header: #{lang}")
        end

        lang

      nil ->
        default_locale
    end
  end

  defp parse_language_tag(tag) do
    case String.split(tag, ";q=") do
      [lang] ->
        # Extract just the language code (e.g., "pt" from "pt-BR")
        lang_code =
          String.trim(lang)
          |> String.split("-")
          |> List.first()

        {lang_code, 1.0}

      [lang, quality] ->
        # Extract just the language code (e.g., "pt" from "pt-BR")
        lang_code =
          String.trim(lang)
          |> String.split("-")
          |> List.first()

        case Float.parse(String.trim(quality)) do
          {q, _} -> {lang_code, q}
          :error -> {lang_code, 1.0}
        end

      _ ->
        {String.trim(tag), 0.0}
    end
  end
end
