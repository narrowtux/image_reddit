defmodule ImageReddit.Downloader do
  use GenStage
  require Logger

  def start_link do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:producer, %{
      demand: 0,
      pending_downloads: []
    }}
  end

  def download(post) do
    GenStage.cast(__MODULE__, {:download, post})
  end

  def handle_cast({:download, post}, %{
    demand: demand,
    pending_downloads: pending
  }) do
    if demand > 0 do
      {:noreply, [post], %{
        demand: demand - 1,
        pending_downloads: pending
      }}
    else
      {:noreply, [], %{
        demand: demand,
        pending_downloads: pending ++ [post]
      }}
    end
  end

  def handle_demand(new_demand, %{
    demand: demand,
    pending_downloads: pending
  }) do
    new_demand = demand + new_demand
    Logger.info("New demand: #{new_demand}")
    {events, pending} = Enum.split(pending, new_demand)
    demand = new_demand - length(events)
    {:noreply, events, %{
      demand: demand,
      pending_downloads: pending
    }}
  end
end
