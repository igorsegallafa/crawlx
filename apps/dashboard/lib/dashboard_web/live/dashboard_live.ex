defmodule DashboardWeb.DashboardLive do
  use DashboardWeb, :live_view

  @interval_update 5000
  @auto_update true

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
    items = get_items_from_cache()

    socket
    |> assign(items: items)
  end

  defp get_items_from_cache() do
    # clear current cache
    Cachex.clear(:crawlx_web)
    Cachex.load(:crawlx_web, "/tmp/crawlx")

    query = Cachex.Query.create(true, { :key, :value })

    :crawlx_web
    |> Cachex.stream!(query)
    |> Enum.to_list
  end
end
