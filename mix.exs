defmodule Tremtec.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def cli do
    [
      preferred_envs: [precommit: :test]
    ]
  end

  defp deps do
    []
  end

  defp aliases do
    [
      setup: ["do --app tremtec setup"],
      "ecto.setup": ["do --app tremtec ecto.setup"],
      "ecto.reset": ["do --app tremtec ecto.reset"],
      "ecto.migrate": ["do --app tremtec ecto.migrate"],
      "ecto.create": ["do --app tremtec ecto.create"],
      test: ["do --app tremtec test"],
      "assets.setup": ["do --app tremtec assets.setup"],
      "assets.build": ["do --app tremtec assets.build"],
      "assets.deploy": ["do --app tremtec assets.deploy"],
      "phx.server": ["do --app tremtec phx.server"],
      precommit: [
        "compile --warning-as-errors",
        "do --app tremtec precommit"
      ]
    ]
  end
end
