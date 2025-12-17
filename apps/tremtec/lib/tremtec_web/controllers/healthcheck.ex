defmodule TremtecWeb.HealthcheckController do
  use TremtecWeb, :controller

  # health check endpoint
  def healthz(conn, _params) do
    # TODO: check database connectivity and other dependencies here
    send_resp(conn, 200, "OK")
  end
end
