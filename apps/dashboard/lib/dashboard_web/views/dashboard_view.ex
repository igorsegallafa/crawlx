defmodule DashboardWeb.DashboardView do
  use DashboardWeb, :view

  alias Dashboard.Helper.SpiderStats

  @products_keyword [
    ["RTX 3060TI", "RTX3060 TI", "RTX 3060 TI"],
    ["RTX 3060", "RTX3060"],
    ["RX 6800", "RX6800"],
    ["RX 5700", "RX5700"],
    ["RX 5600", "RX5600"],
    ["RTX 3070", "RTX3070"],
  ]

  def get_products_keyword(), do: @products_keyword
  def get_spiders_stats(), do: SpiderStats.get_spiders_stats()

  def group_products_by_keyword(items) do
    items
    |> Enum.map(fn {_spider_name, items_list} -> flatten_items_list(items_list) end)
    |> List.flatten
    |> Enum.group_by(fn item -> find_first_title_match_with_keyword(item) end)
  end

  defp flatten_items_list(items_list) do
    items_list
    |> Enum.map(fn {_uid, parsed_item} -> parsed_item end)
  end

  defp find_first_title_match_with_keyword(item) do
    @products_keyword
    |> Enum.filter(fn keyword -> String.contains?(String.upcase(item["title"]), keyword) end)
    |> List.first
  end
end
