defmodule Crawler.Pipeline.NormalizeParsedItem do
  require Logger

  @scan_product_price_regex ~r/R\$.?(\d+(.|,))+/

  @impl Crawly.Pipeline
  def run(item, state, _opts \\ []) do
    normalized_item =
      item
      |> normalize_parsed_item

    {normalized_item, state}
  end

  defp normalize_parsed_item(item) do
    item
    |> Enum.map(fn {k, v} -> {k, normalize(k, v)} end)
    |> Map.new
  end

  defp normalize(:title, value), do: String.trim(value)
  defp normalize(:price, value = "Out of Stock"), do: value
  defp normalize(:price, value) do
    @scan_product_price_regex
    |> Regex.scan(value)
    |> List.first
    |> hd
  end
  defp normalize(_, value), do: value
end