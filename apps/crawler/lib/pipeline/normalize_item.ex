defmodule Crawler.Pipeline.NormalizeItem do
  require Logger

  @scan_product_price_regex ~r/R\$.?(\d+(.|,))+/
  @blacklist_title_words [
    "gamer",
    "computador",
  ]

  @impl Crawly.Pipeline
  def run(item, state, _opts \\ []) do
    normalized_item =
      item
      |> normalize_item

    case Map.has_key?(normalized_item, :price) and Map.has_key?(normalized_item, :title) and Map.has_key?(normalized_item, :url) do
      true -> {normalized_item, state}
      false -> {false, state}
    end
  end

  defp normalize_item(item) do
    item
    |> Enum.map(fn {k, v} -> {k, normalize(k, v)} end)
    |> Enum.filter(fn {k, v} -> is_valid_item?(k, v) end)
    |> Map.new
  end

  defp normalize(:title, value), do: String.trim(value)
  defp normalize(:price, _value = nil), do: Decimal.new(0)
  defp normalize(:price, value) when is_float(value) or is_integer(value), do: Decimal.new("#{value}")
  defp normalize(:price, value) do
    @scan_product_price_regex
    |> Regex.scan(value)
    |> List.first
    |> hd
    |> Money.parse!
    |> Money.to_decimal
  end
  defp normalize(_, value), do: value

  defp is_valid_item?(:title, value) do
    value
    |> String.downcase()
    |> String.contains?(@blacklist_title_words)
    |> Kernel.not()
  end
  defp is_valid_item?(_, _value), do: true
end