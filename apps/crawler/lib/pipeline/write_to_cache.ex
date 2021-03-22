defmodule Crawler.Pipeline.WriteToCache do

  @impl Crawly.Pipeline
  def run(item, state, _opts \\ []) do
    spider_name = to_string(state.spider_name)
    parsed_item = JSON.decode!(item)

    cache_value = Cachex.get(:crawlx, spider_name)

    updated_map =
      case cache_value do
        {:ok, nil} -> %{parsed_item["title"] => parsed_item}
        {:ok, value} -> Map.put(value, parsed_item["title"], parsed_item)
      end

    # upsert value on cache
    case cache_value do
      {:ok, nil} -> Cachex.put(:crawlx, spider_name, updated_map)
      {:ok, _value} -> Cachex.update(:crawlx, spider_name, updated_map)
    end

    # save cache
    Cachex.dump(:crawlx, "/tmp/crawlx")

    {item, state}
  end

end