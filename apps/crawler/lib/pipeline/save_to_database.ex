defmodule Crawler.Pipeline.SaveToDatabase do
  require Logger

  @insert_product_query """
    INSERT INTO crawlx.products (url_hash, spider_name, title, url, updated_at)
    VALUES (?, ?, ?, ?, NOW())
    ON DUPLICATE KEY UPDATE updated_at = NOW()
  """

  @insert_product_price_query """
    INSERT IGNORE INTO crawlx.products_price_hist (product_id, price, date)
    SELECT ?, ?, NOW()
    FROM (
      SELECT IFNULL((
          SELECT price
          FROM products_price_hist
          WHERE product_id = ? ORDER BY id DESC LIMIT 1), NULL) AS price
    ) last_price
    WHERE last_price.price != ?;
  """

  @impl Crawly.Pipeline
  def run(item, state, _opts \\ []) do
    spider_name = to_string(state.spider_name)
    query_result =
      CrawlxRepo.transaction(fn() ->
        item
        |> insert_product(spider_name)
        |> insert_product_price_hist(item)
      end)

    case query_result do
      {:ok, results} -> process_result(results, item, state)
      {:error, _} -> {false, state}
    end
  end

  defp insert_product(_item = %{title: title, url: url}, spider_name) do
    spider_name = spider_name
    query_params = [
      get_hash_from_product_url(url),
      spider_name,
      title,
      url,
    ]

    CrawlxRepo.query!(@insert_product_query, query_params).last_insert_id
  end

  defp insert_product_price_hist(product_id, _item = %{price: price}) do
    query_params = [
      product_id,
      price,
      product_id,
      price
    ]

    CrawlxRepo.query!(@insert_product_price_query, query_params)
  end

  defp process_result(results, item, state) do
    if results.num_rows > 0, do: {item, state},
    else: {false, state}
  end

  defp get_hash_from_product_url(url), do:
    :crypto.hash(:md5, url) |> Base.encode16(case: :lower)
end