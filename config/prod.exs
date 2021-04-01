use Mix.Config

config :dashboard, DashboardWeb.Endpoint,
  url: [host: "example.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info

config :crawler, Crawler.Scheduler, jobs: [{"*/3 * * * *", {Crawler.Scheduler, :run_spiders, []}}]

import_config "prod.secret.exs"
