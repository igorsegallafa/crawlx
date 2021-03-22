defmodule Crawler.MixProject do
  use Mix.Project

  def project do
    [
      app: :crawler,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Crawler.Application, []},
      extra_applications: [:logger, :cachex]
    ]
  end

  defp deps do
    [
      {:json, "~> 1.4"},
      {:crawly, "~> 0.13.0"},
      {:floki, "~> 0.30.0"}
    ]
  end
end
