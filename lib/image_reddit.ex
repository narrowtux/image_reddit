defmodule ImageReddit do
  use Application

  def start(_, _) do
    import Supervisor.Spec

    children = [
      worker(ImageReddit.Downloader, [])
    ] ++ for id <- 1..4 do
      worker(ImageReddit.Downloader.Worker, [], id: :"Elixir.ImageReddit.Downloader.Worker#{id}")
    end

    Supervisor.start_link(children, strategy: :one_for_one, name: ImageReddit.Supervisor)
  end
end
