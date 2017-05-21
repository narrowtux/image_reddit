defmodule ImageReddit.Downloader.Worker do
  use GenStage
  require Logger

  def start_link do
    GenStage.start_link(__MODULE__, [])
  end

  def init(_) do
    {:consumer, nil, subscribe_to: [{ImageReddit.Downloader, max_demand: 1}]}
  end

  def handle_events([post], _from, _) do
    Logger.info("Downloading post #{post["id"]} - #{post["title"]}")
    case HTTPoison.get(post["url"]) do
      {:ok, res} ->
        if (res.body != "") do
          File.write!(post["path"], res.body)
          Logger.info("Downloaded post #{post["id"]}")
        end
      {:error, error} ->
        Logger.error(error)
    end
    {:noreply, [], nil}
  end
end
