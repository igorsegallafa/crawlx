defmodule DashboardWeb.DashboardLive do
  use DashboardWeb, :live_view

  alias Dashboard.Helper.SpiderStats

  @interval_update 5000
  @auto_update true

  @get_products_hist_query """
    WITH
      last_product_price_id AS (
          SELECT pp.product_id,
                 MAX(pp.id) AS last_id
          FROM products_price_hist pp
          GROUP BY pp.product_id
      )
      SELECT p.spider_name,
             p.title,
             p.url,
             pph.price,
             p.updated_at
      FROM products p
      JOIN last_product_price_id lpp ON lpp.product_id = p.id
      JOIN products_price_hist pph on pph.id = lpp.last_id;
  """

  def mount(_params, _session, socket) do
    send_update_event(@auto_update)
    {:ok, update(socket)}
  end

  def render(assigns) do
    render(DashboardWeb.DashboardView, "index.html", assigns)
  end

  def handle_info(:update, socket) do
    send_update_event(@auto_update)

    {:noreply, update(socket)}
  end

  defp send_update_event(true), do: Process.send_after(self(), :update, @interval_update)
  defp send_update_event(_), do: nil

  defp update(socket) do
    items = get_items_from_database()
    spiders_stats = SpiderStats.get_spiders_stats()

    socket
    |> assign(items: items, spiders_stats: spiders_stats)
  end

  defp get_items_from_database() do
    @get_products_hist_query
    |> CrawlxRepo.query!()
    |> format_query_result_as_map
  end

  defp format_query_result_as_map(results) do
    columns = results.columns
    rows = results.rows

    Enum.map(rows, fn row ->
      columns
      |> Enum.zip(row)
      |> Enum.into(%{})
    end)
  end
end
