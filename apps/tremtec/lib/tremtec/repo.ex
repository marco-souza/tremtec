defmodule Tremtec.Repo do
  use Ecto.Repo,
    otp_app: :tremtec,
    adapter: Ecto.Adapters.SQLite3
end
