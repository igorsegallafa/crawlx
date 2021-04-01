import Config

config :crawly,
  closespider_timeout: 10,
  concurrent_requests_per_domain: 8,
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
    Crawler.Pipeline.NormalizeItem,
    Crawler.Pipeline.SaveToDatabase,
    Crawler.Pipeline.SendNotification
  ]

config :money,
       default_currency: :BRL,
       separator: ".",
       delimiter: ","

# Configures the Cron jobs
config :crawler, Crawler.Scheduler,
  jobs: [
    # Every 3 minutes
#    {"*/3 * * * *",   {Crawler.Scheduler, :run_spiders, []} }
  ]

# Configures the endpoint
config :dashboard, DashboardWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9p4l7qsobg6hzvNiVfxqvxrEe74PByPjADasqBLqO9Lig5Ffqp36lHLJr6id96dK",
  render_errors: [view: DashboardWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Dashboard.PubSub,
  live_view: [signing_salt: "9s9ANrvf"]

# Configures MySQL Repo
config :crawler, CrawlxRepo,
       adapter: Ecto.Adapters.MyXQL,
       database: "crawlx",
       username: "root",
       password: "123456",
       hostname: "localhost",
       port: 3306,
       pool_size: 1,
       url: nil

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Telegram
config :telegex,
       token: "TELEGRAM_TOKEN",
       timeout: 1000 * 15,
       recv_timeout: 1000 * 10

# Use Poison for JSON parsing in Phoenix
config :phoenix, :json_library, Poison

import_config "#{Mix.env()}.exs"
