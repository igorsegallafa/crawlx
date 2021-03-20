import Config

config :crawly,
  closespider_timeout: 10,
  concurrent_requests_per_domain: 8,
  fetcher: {Crawly.Fetchers.Splash, [base_url: "http://localhost:8050/render.html"]},
  middlewares: [
   Crawly.Middlewares.DomainFilter,
   Crawly.Middlewares.UniqueRequest,
   {
     Crawly.Middlewares.RequestOptions,
     [
       timeout: 30_000,
       recv_timeout: 15000,
       hackney: [:insecure]
     ]
   },
   {
     Crawly.Middlewares.UserAgent,
     user_agents: [
       "Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0",
       "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36",
       "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Safari/537.36 OPR/38.0.2220.41"
     ]
   }
  ],
  pipelines: [
   {Crawly.Pipelines.Validate, fields: [:url, :title]},
   {Crawly.Pipelines.DuplicatesFilter, item_id: :url},
   Crawly.Pipelines.JSONEncoder,
   {Crawly.Pipelines.WriteToFile, extension: "json", folder: "/tmp"}
  ]

# Configures the endpoint
config :dashboard, DashboardWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9p4l7qsobg6hzvNiVfxqvxrEe74PByPjADasqBLqO9Lig5Ffqp36lHLJr6id96dK",
  render_errors: [view: DashboardWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Dashboard.PubSub,
  live_view: [signing_salt: "9s9ANrvf"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Poison for JSON parsing in Phoenix
config :phoenix, :json_library, Poison

import_config "#{Mix.env()}.exs"
