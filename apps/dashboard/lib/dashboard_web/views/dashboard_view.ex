defmodule DashboardWeb.DashboardView do
  use DashboardWeb, :view

  alias Dashboard.Helper.SpiderStats

  @products_keyword [
    ["RTX 3060", "RTX3060"]
  ]

  def get_products_keyword(), do: @products_keyword

  def get_spiders_stats(), do: SpiderStats.get_spiders_stats()

  def is_product_title_in_keyword(title, products_keyword) do
    products_keyword
    |> Enum.map(fn keyword -> String.contains?(title, keyword) end)
    |> Enum.filter(fn value -> value == true end)
    |> Enum.empty?()
    |> Kernel.!
  end
end
