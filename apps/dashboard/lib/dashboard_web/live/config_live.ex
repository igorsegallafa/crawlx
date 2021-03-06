defmodule DashboardWeb.ConfigLive do
  use DashboardWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, update(socket)}
  end

  def render(assigns) do
    render(DashboardWeb.ConfigView, "index.html", assigns)
  end

  def handle_event("save_products_keyword", _params = %{"content" => content}, socket) do
    with(
      :ok <- save_products_keyword(content)
    ) do
      {:noreply, update(socket) |> put_flash(:info, "Products keyword saved successfully!")}
    else
      {:error, _} -> {:noreply, update(socket) |> put_flash(:error, "An error has occurred when saving products keyword!")}
    end
  end

  def handle_event("save", _params = %{"spider_content" => content, "spider_name" => spider_name}, socket) do
    with(
      :ok <- save_urls_content_path(spider_name, content)
    ) do
      {:noreply, update(socket) |> put_flash(:info, "Spider content URLs saved successfully!")}
    else
      {:error, _} -> {:noreply, update(socket) |> put_flash(:error, "An error has occurred when saving urls content path!")}
    end
  end

  defp update(socket) do
    socket
    |> assign(spiders_url: get_spiders_url())
    |> assign(products_keyword_content: get_products_keyword())
  end

  defp get_spiders_url() do
    Crawler.get_spiders()
    |> Enum.map(fn spider -> spider |> to_string() |> String.replace("Elixir.Crawler.Spider.", "") end)
    |> Enum.map(fn spider_name -> {spider_name, get_urls_content_path(spider_name)} end)
    |> Map.new()
  end

  defp get_products_keyword() do
    File.cwd!
    |> Path.join("products_keyword.json")
    |> File.read!()
  end

  defp get_urls_content_path(spider_name) do
    File.cwd!
    |> Path.join("#{spider_name}.json")
    |> File.read!()
  end

  defp save_products_keyword(content) do
    File.cwd!
    |> Path.join("products_keyword.json")
    |> File.write(content)
  end

  defp save_urls_content_path(spider_name, content) do
    File.cwd!
    |> Path.join("#{spider_name}.json")
    |> File.write(content)
  end
end
