defmodule DashboardWeb.SpiderLive do
  use DashboardWeb, :live_view

  alias Dashboard.Helper.SpiderStats

  @interval_update 5000
  @auto_update true

  def mount(_params, _session, socket) do
    send_update_event(@auto_update)
    {:ok, update(socket)}
  end

  def render(assigns) do
    render(DashboardWeb.SpiderView, "index.html", assigns)
  end

  def handle_info(:update, socket) do
    send_update_event(@auto_update)

    {:noreply, update(socket)}
  end

  def handle_event("run_spider", params, socket) do
    response = HTTPoison.get!("http://localhost:4001/spiders/#{params["spider_name"]}/schedule")

    {:noreply, update(socket) |> put_flash(:info, response.body)}
  end

  def handle_event("stop_spider", params, socket) do
    response = HTTPoison.get!("http://localhost:4001/spiders/#{params["spider_name"]}/stop")

    {:noreply, update(socket) |> put_flash(:info, response.body)}
  end

  defp send_update_event(true), do: Process.send_after(self(), :update, @interval_update)
  defp send_update_event(_), do: nil

  defp update(socket) do
    socket
    |> assign(spiders_stats: SpiderStats.get_spiders_stats())
  end
end
