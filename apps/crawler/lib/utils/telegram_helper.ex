defmodule Crawler.Utils.TelegramHelper do
  @chat_group_id -1
  @enabled true

  def send_message(message, opts \\ []) do
    if @enabled, do: Telegex.send_message(@chat_group_id, message, opts),
    else: nil
  end
end