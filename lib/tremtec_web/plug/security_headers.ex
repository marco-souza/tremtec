defmodule TremtecWeb.Plug.SecurityHeaders do
  @moduledoc """
  Plug for adding security headers to responses.

  Configures Content Security Policy (CSP) and other security headers
  to protect against common web vulnerabilities.
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> put_csp_header()
    |> put_resp_header("x-content-type-options", "nosniff")
    |> put_resp_header("x-frame-options", "SAMEORIGIN")
    |> put_resp_header("x-xss-protection", "1; mode=block")
  end

  # Content Security Policy header
  # Allows Cloudflare Turnstile widget to work properly
  defp put_csp_header(conn) do
    csp_header = build_csp_header()
    put_resp_header(conn, "content-security-policy", csp_header)
  end

  defp build_csp_header do
    [
      "default-src 'self'",
      "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://challenges.cloudflare.com",
      "frame-src 'self' https://challenges.cloudflare.com https://*.cloudflare.com",
      "connect-src 'self' https://challenges.cloudflare.com",
      "style-src 'self' 'unsafe-inline' https://challenges.cloudflare.com https://*.cloudflare.com",
      "img-src 'self' data: https:",
      "font-src 'self' data:",
      "base-uri 'self'",
      "form-action 'self'",
      "frame-ancestors 'self'",
      "upgrade-insecure-requests"
    ]
    |> Enum.join("; ")
  end
end
