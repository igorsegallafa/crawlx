defmodule DashboardWeb.DashboardView do
  use DashboardWeb, :view

  @products_keyword [
    ["RTX 3060", "RTX3060"]
  ]

  def get_products_keyword(), do: @products_keyword

  def get_know_spiders(), do: Crawler.get_spiders() |> Enum.map(fn spider -> to_string(spider) |> String.replace("Elixir.", "") end)

  def is_product_title_in_keyword(title, products_keyword) do
    products_keyword
    |> Enum.map(fn keyword -> String.contains?(title, keyword) end)
    |> Enum.filter(fn value -> value == true end)
    |> Enum.empty?()
    |> Kernel.!
  end
end
