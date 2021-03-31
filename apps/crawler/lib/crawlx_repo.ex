defmodule Crawler.CrawlxRepo do
  use Ecto.Repo, [
    otp_app: :crawler,
    adapter: Ecto.Adapters.MyXQL,
  ]
end