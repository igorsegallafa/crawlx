defmodule DashboardWeb.DashboardView do
  use DashboardWeb, :view

  alias Dashboard.Helper.SpiderStats

  def get_products_keyword() do
    {:ok, products_keyword} =
      File.cwd!
      |> Path.join("products_keyword.json")
      |> File.read!()
      |> Poison.decode()

    products_keyword
  end
  def get_spiders_stats(), do: SpiderStats.get_spiders_stats()

  def group_products_by_keyword(items) do
    items
    |> Enum.group_by(fn item -> find_first_title_match_with_keyword(item) end)
  end

  defp find_first_title_match_with_keyword(item) do
    get_products_keyword()
    |> Enum.filter(fn keyword -> String.contains?(String.upcase(item["title"]), keyword) end)
    |> List.first
  end

  defp get_price_as_string(price) do
    price
    |> Money.parse!()
    |> Money.to_string()
  end
end
