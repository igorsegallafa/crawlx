defmodule Dashboard.Application do
  use Application

  def start(_type, _args) do
    children = [
      DashboardWeb.Telemetry,
      {Phoenix.PubSub, name: Dashboard.PubSub},
      {Cachex, name: :crawlx_web},
      DashboardWeb.Endpoint,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dashboard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DashboardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
