use Mix.Config

config :dashboard, DashboardWeb.Endpoint,
  http: [port: 5000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../apps/dashboard/assets", __DIR__)
    ]
  ]

config :dashboard, DashboardWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/dashboard_web/(live|views)/.*(ex)$",
      ~r"lib/dashboard_web/templates/.*(eex)$",
      ~r"assets/css/.*(css)"
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :telegex,
  enabled: false,
  token: "-1",
  chat_id: 0

import_config "dev.secret.exs"