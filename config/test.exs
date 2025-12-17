import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :tremtec, Tremtec.Repo,
  database: Path.expand("../apps/tremtec/tremtec_test.db", __DIR__),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tremtec, TremtecWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "TK3h5CdMFDr51jt8/L/++1fQu4q2sXw26UrTerJ5HsNosMCcbTcr8tHsV1L0us9Z",
  server: false

# In test we don't send emails
config :tremtec, Tremtec.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warning

# Allow example.com in tests
config :tremtec, :accepted_email_domains, ["tremtec.com", "example.com"]
