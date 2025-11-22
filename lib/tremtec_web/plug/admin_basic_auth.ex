defmodule TremtecWeb.Plug.AdminBasicAuth do
  @moduledoc """
  Minimal Basic Auth plug for protecting admin routes.

  Options:
    * :username - admin username (defaults to ENV ADMIN_USER or "admin")
    * :password - admin password (defaults to ENV ADMIN_PASS or "admin")
  """

  import Plug.Conn

  require Logger

  # define struct state
  defmodule AuthState do
    defstruct [:username, :password]
  end

  @behaviour Plug

  @impl Plug
  def init(%{username: username, password: password}) do
    %AuthState{username: username, password: password}
  end

  @impl Plug
  def init(:runtime) do
    %AuthState{
      username: Application.get_env(:tremtec, :admin_user, "admin"),
      password: Application.get_env(:tremtec, :admin_password, "admin")
    }
  end

  @impl Plug
  def call(conn, %AuthState{username: expected_user, password: expected_pass} = state) do
    Logger.info(
      "Admin access attempt from #{conn.remote_ip |> Tuple.to_list() |> Enum.join(".")}"
    )

    Logger.debug("State: #{inspect(state)}")

    case get_req_header(conn, "authorization") do
      ["Basic " <> base64] ->
        with {:ok, creds} <- Base.decode64(base64),
             [user, pass] <- String.split(creds, ":", parts: 2) do
          Logger.debug("User: #{user}, Pass: #{String.duplicate("*", String.length(pass))}")

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
