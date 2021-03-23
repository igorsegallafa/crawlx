defmodule Crawler.Pipeline.WriteToCache do
  alias Crawler.Utils.TelegramHelper

  require Logger

  @impl Crawly.Pipeline
  def run(item, state, _opts \\ []) do
    spider_name = to_string(state.spider_name)
    parsed_item =
      item
      |> JSON.decode!()
      |> Map.put("datetime", DateTime.utc_now() |> DateTime.to_string())

    cache_value = Cachex.get(:crawlx, spider_name)
    updated_map =
      case cache_value do
        {:ok, nil} -> %{parsed_item["title"] => parsed_item}
        {:ok, value} -> update_and_check_item_state(value, parsed_item)
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

  defp update_and_check_item_state(cache_map, parsed_item) do
    product_title = parsed_item["title"]
    product = Map.get(cache_map, product_title)

    # product has changed your state?
    has_state_changed? = product["price"] != parsed_item["price"]
    alert_message =
      if parsed_item["price"] == "Out of Stock", do: "O produto `#{parsed_item["title"]}` saiu de estoque!\n#{parsed_item["url"]}",
      else: "#{parsed_item["title"]} está disponível (#{parsed_item["price"]})!\n#{parsed_item["url"]}"

    # send telegram message
    if has_state_changed?, do:
      TelegramHelper.send_message(alert_message)

    Map.put(cache_map, product_title, parsed_item)
  end

end