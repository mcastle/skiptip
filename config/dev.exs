use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
port = System.get_env("PORT") || 4000
config :skiptip, Skiptip.Endpoint,
  http: [port: port],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin"]]

# Watch static and templates for browser reloading.
config :skiptip, Skiptip.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :skiptip, Skiptip.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "skiptip",
  password: "skiptip",
  database: "skiptip_development",
  hostname: "localhost",
  pool_size: 10,
  extensions: [{Geo.PostGIS.Extension, library: Geo}]

config :skiptip, Skiptip.DevelopmentRepo,
  adapter: Ecto.Adapters.Postgres,
  username: "skiptip",
  password: "skiptip",
  database: "skiptip_development",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  extensions: [{Geo.PostGIS.Extension, library: Geo}]
