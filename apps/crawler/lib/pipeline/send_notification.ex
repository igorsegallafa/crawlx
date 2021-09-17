defmodule Crawler.Pipeline.SendNotification do
  require Logger

  alias Crawler.Utils.TelegramHelper

  @impl Crawly.Pipeline
  def run(item = %{price: price}, state, _opts \\ []) do
    is_product_out_of_stock? = Decimal.eq?(price, 0)

    item
    |> get_notification_message(is_product_out_of_stock?)
    |> TelegramHelper.send_message()

    {false, state}
  end

  defp get_notification_message(%{title: title, url: url}, _is_product_out_of_stock? = true) do
    "O produto `#{title}` saiu de estoque!\n#{url}"
  end
  defp get_notification_message(%{title: title, url: url, price: price}, _) do
    formatted_price =
      price
      |> Money.parse!()
      |> Money.to_string()

    "#{title} está disponível (#{formatted_price})!\n#{url}"
  end
end