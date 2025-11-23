defmodule TremtecWeb.Plug.AdminBasicAuth do
  @moduledoc """
  Minimal Basic Auth plug for protecting admin routes.

  Credentials are loaded from runtime configuration (set via ADMIN_USER and ADMIN_PASS
  environment variables). Credentials are required and must be explicitly set - there
  are no defaults.

  Options:
    * :runtime - Load credentials from Application config (requires ADMIN_USER and ADMIN_PASS env vars)
  """

  import Plug.Conn

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
    username = Application.get_env(:tremtec, :admin_user)
    password = Application.get_env(:tremtec, :admin_password)

    # Check if we have valid credentials (not placeholders from build time)
    if is_placeholder?(username) or is_placeholder?(password) do
      raise """
      Admin credentials not configured!

      Required environment variables:
        * ADMIN_USER - Admin username
        * ADMIN_PASS - Admin password

      These variables must be explicitly set before the application starts.

      Example:
        export ADMIN_USER='your-secure-username'
        export ADMIN_PASS='your-secure-password'
      """
    end

    %AuthState{username: username, password: password}
  end

  # Check if credentials are just build-time placeholders
  defp is_placeholder?("placeholder-build-user"), do: true
  defp is_placeholder?("placeholder-build-pass"), do: true
  defp is_placeholder?(_), do: false

  @impl Plug
  def call(conn, %AuthState{username: expected_user, password: expected_pass}) do
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
    byte_size(a) == byte_size(b) and Plug.Crypto.secure_compare(a, b)
  end
end
