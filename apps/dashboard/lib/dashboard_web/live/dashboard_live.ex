defmodule DashboardWeb.DashboardLive do
  use DashboardWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    render(DashboardWeb.DashboardView, "index.html", assigns)
  end
end
