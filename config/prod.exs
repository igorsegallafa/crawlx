use Mix.Config

config :dashboard, DashboardWeb.Endpoint,
  check_origin: false,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info

config :crawler, Crawler.Scheduler, jobs: [{"*/3 * * * *", {Crawler.Scheduler, :run_spiders, []}}]

import_config "prod.secret.exs"
