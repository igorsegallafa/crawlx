use Mix.Config

config :dashboard, DashboardWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
