defmodule Crawler do
  alias Crawly.Engine

  def run(spider) do
    [Crawler.Spider, spider]
    |> Module.concat()
    |> Engine.start_spider()
  end
end
