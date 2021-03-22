defmodule Crawler.Scheduler do
  use Quantum, otp_app: :crawler

  alias Crawly.Engine

  @crawler_spiders [
    Crawler.Spider.Pichau,
    Crawler.Spider.Kabum,
    Crawler.Spider.TerabyteShop
  ]

  def run_spiders() do
    @crawler_spiders
    |> Enum.each(&Engine.start_spider/1)
  end
end