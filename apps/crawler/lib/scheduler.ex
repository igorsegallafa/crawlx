defmodule Crawler.Scheduler do
  use Quantum, otp_app: :crawler

  alias Crawly.Engine

  def run_spiders() do
    Crawler.get_spiders()
    |> Enum.each(&Engine.start_spider/1)
  end
end