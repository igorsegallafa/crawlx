defmodule Crawler.Application do
  use Application

  require Logger

  def start(_type, _args) do
    children = [
      Crawler.Scheduler,
      CrawlxRepo,
    ]

    opts = [strategy: :one_for_one, name: Crawler.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
