defmodule Crawler.Pipeline.NormalizeItem do
  require Logger

  @scan_product_price_regex ~r/R\$.?(\d+(.|,))+/

  @impl Crawly.Pipeline
  def run(item, state, _opts \\ []) do
    normalized_item =
      item
      |> normalize_item

    {normalized_item, state}
  end

  defp normalize_item(item) do
    item
    |> Enum.map(fn {k, v} -> {k, normalize(k, v)} end)
    |> Map.new
  end

  defp normalize(:title, value), do: String.trim(value)
  defp normalize(:price, _value = nil), do: Decimal.new(0)
  defp normalize(:price, value) when is_float(value), do: Decimal.from_float(value)
  defp normalize(:price, value) do
    @scan_product_price_regex
    |> Regex.scan(value)
    |> List.first
    |> hd
    |> Money.parse!
    |> Money.to_decimal
  end
  defp normalize(_, value), do: value
end