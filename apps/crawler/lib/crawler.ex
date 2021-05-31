defmodule Crawler do
  alias Crawly.Engine

  @crawler_spiders [
    Crawler.Spider.Pichau,
    Crawler.Spider.TerabyteShop
  ]

  def get_spiders(), do: @crawler_spiders

  def run(spider) do
    [Crawler.Spider, spider]
    |> Module.concat()
    |> Engine.start_spider()
  end
end
