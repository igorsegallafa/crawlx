defmodule Crawler.LoadCacheFromDump do
  require Logger

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn ->
      Logger.info("Loading cachex from dump file...")
      Cachex.load(:crawlx, "/tmp/crawlx")

      :ok
    end)
  end

end