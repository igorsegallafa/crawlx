defmodule DashboardWeb.SpiderLive do
  use DashboardWeb, :live_view

  @interval_update 15000
  @auto_update true

  def mount(_params, _session, socket) do
    send_update_event(@auto_update)
    {:ok, socket}
  end

  def render(assigns) do
    render(DashboardWeb.SpiderView, "index.html", assigns)
  end

  def handle_info(:update, socket) do
    send_update_event(@auto_update)
    {:noreply, socket}
  end

  def handle_event("run_spider", params, socket) do
    response = HTTPoison.get!("http://localhost:4001/spiders/#{params["spider_name"]}/schedule")
    response |> IO.inspect()

    {:noreply, socket}
  end

  defp send_update_event(true), do: Process.send_after(self(), :update, @interval_update)
  defp send_update_event(_), do: nil
end
