defmodule TremtecWeb.Plug.PutLocaleSession do
  @moduledoc """
  DEPRECATED: This plug is no longer used.

  Locale determination has been moved to `TremtecWeb.Plug.DetermineLocale`
  which handles cookie preferences and Accept-Language headers.

  This module is kept for backwards compatibility and can be safely removed
  in a future version.
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    # This plug is deprecated and does nothing
    conn
  end
end
