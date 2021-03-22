defmodule Crawler.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Cachex, name: :crawlx},
      Crawler.Scheduler,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Crawler.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
