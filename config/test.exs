use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
port = System.get_env("PORT") || 4001
config :skiptip, Skiptip.Endpoint,
  http: [port: port],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :skiptip, Skiptip.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "skiptip",
  password: "skiptip",
  database: "skiptip_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  extensions: [{Geo.PostGIS.Extension, library: Geo}]

config :skiptip, Skiptip.DevelopmentRepo,
  adapter: Ecto.Adapters.Postgres,
  username: "skiptip",
  password: "skiptip",
  database: "skiptip_development",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  extensions: [{Geo.PostGIS.Extension, library: Geo}]
