defmodule TremtecWeb.Plug.AdminBasicAuth do
  @moduledoc """
  Minimal Basic Auth plug for protecting admin routes.

  Options:
    * :username - admin username (defaults to ENV ADMIN_USER or "admin")
    * :password - admin password (defaults to ENV ADMIN_PASS or "admin")
  """

  import Plug.Conn

  @behaviour Plug

  @impl Plug
  def init(opts) do
    %{
      username: Map.get(opts, :username) || System.get_env("ADMIN_USER", "admin"),
      password: Map.get(opts, :password) || System.get_env("ADMIN_PASS", "admin")
    }
  end

  @impl Plug
  def call(conn, %{username: expected_user, password: expected_pass}) do
    case get_req_header(conn, "authorization") do
      ["Basic " <> base64] ->
        with {:ok, creds} <- Base.decode64(base64),
             [user, pass] <- String.split(creds, ":", parts: 2) do
          if secure_compare(user, expected_user) and secure_compare(pass, expected_pass) do
            conn
          else
            unauthorized(conn)
          end
        else
          _ -> unauthorized(conn)
        end

      _ ->
        unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_resp_header("www-authenticate", ~s(Basic realm="Admin"))
    |> send_resp(:unauthorized, "Unauthorized")
    |> halt()
  end

  # Constant-time compare to mitigate timing attacks
  defp secure_compare(a, b) when is_binary(a) and is_binary(b) do
    (byte_size(a) == byte_size(b) and :crypto.strong_rand_bytes(1)) &&
      Plug.Crypto.secure_compare(a, b)
  end
end
