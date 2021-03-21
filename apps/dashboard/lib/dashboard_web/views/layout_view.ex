defmodule DashboardWeb.LayoutView do
  use DashboardWeb, :view

  def menu(socket) do
    [
      {"Dashboard", "/"},
      {"Spiders", Routes.spider_path(socket, :index)},
      {"Live Dashboard", Routes.live_dashboard_path(socket, :home)},
    ]
  end
end
