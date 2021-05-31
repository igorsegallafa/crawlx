defmodule DashboardWeb.LayoutView do
  use DashboardWeb, :view

  def menu(socket) do
    [
      {"Dashboard", "/"},
      {"Spiders", Routes.spider_path(socket, :index)},
      {"Config", Routes.config_path(socket, :index)},
    ]
  end
end
