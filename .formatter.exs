[
  import_deps: [:ecto, :ecto_sql, :phoenix],
  subdirectories: ["apps/*"],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: [
    "*.{heex,ex,exs}",
    "{config}/**/*.{heex,ex,exs}"
  ]
]
