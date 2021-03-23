defmodule Dashboard.Helper.SpiderStats do

  def get_spiders_stats() do
    Crawler.get_spiders()
    |> Enum.map(&get_spider_stats/1)
  end

  def get_spider_stats(spider) do
    spider_name =
      spider
      |> to_string()
      |> String.replace("Elixir.", "")

    response_spider = HTTPoison.get!("http://localhost:4001/spiders/#{spider_name}/scheduled-requests")
    response_url = HTTPoison.get!(spider.base_url())

    %{
      name: spider_name,
      is_running: response_spider.body != "Spider is not running",
      web_successful: response_url.status_code >= 200 && response_url.status_code <= 226
    }
  end

end