defmodule DashboardWeb.DashboardView do
  use DashboardWeb, :view

  alias Dashboard.Helper.SpiderStats

  @products_keyword [
    ["RTX 3060TI", "RTX3060 TI", "RTX 3060 TI", "RTX 3060TI", "RTX 3060 Ti"],
    ["RTX 3060", "RTX3060"],
    ["RX 6800", "RX6800"],
    ["RX 5700", "RX5700"],
    ["RX 5600", "RX5600"],
    ["RTX 3070", "RTX3070"],
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
