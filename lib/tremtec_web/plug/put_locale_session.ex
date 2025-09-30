defmodule TremtecWeb.Plug.PutLocaleSession do
  @moduledoc """
  A plug to put the locale in the session.
  """

  import Plug.Conn

  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    Logger.info("Putting locale in session: #{inspect(conn.params)}")
    locale = get_locale_for_user(conn.params)
    Gettext.put_locale(TremtecWeb.Gettext, locale)

    conn
    |> put_session(:locale, locale)
  end

  defp get_locale_for_user(params) do
    case params do
      %{"locale" => locale} -> locale
      _ -> "pt"
    end
  end
end
