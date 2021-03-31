defmodule Crawlx.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp deps do
    [
      {:cachex, "~> 3.3"},
      {:myxql, "~> 0.4.0"},
      {:ecto_sql, "~> 3.5"}
    ]
  end
end
