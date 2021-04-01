defmodule Crawler.Utils.TelegramHelper do
  @enabled Application.fetch_env!(:telegex, :enabled)
  @chat_id Application.fetch_env!(:telegex, :chat_id)

  def send_message(message, opts \\ []) do
    if @enabled, do: Telegex.send_message(@chat_id, message, opts),
    else: nil
  end
end