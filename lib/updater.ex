defmodule ImageReddit.Updater do
  require Logger
  def update_all() do
    get_config(:subreddits)
    |> Enum.each(&update/1)
  end

  def update(subreddit) do
    Logger.info("Updating images in subreddit #{subreddit}")

    posts =
      HTTPoison.get!("https://api.reddit.com/r/#{subreddit}/")
      |> Map.get(:body)
      |> Poison.decode!
      |> Map.get("data")
      |> Map.get("children")
      |> Enum.map(&Map.get(&1, "data"))

    Logger.info("#{length(posts)} posts returned")

    path =
      get_config(:output_dir)
      |> Path.join(subreddit)
      |> Path.absname

    File.mkdir_p!(path)

    images =
      posts
      |> Enum.filter(&is_image?/1)
      |> Enum.map(fn post ->
        uri = URI.parse(post["url"])
        ext = Path.extname(uri.path)

        image_path = Path.join(path, "#{post["id"]}#{ext}")
        Map.put post, "path", image_path
      end)
      |> Enum.filter(fn post ->
        !File.exists?(post["path"])
      end)
      |> Enum.each(&ImageReddit.Downloader.download/1)

    Logger.info("Beginning to download")

  end

  def get_config(key) do
    :image_reddit
    |> Application.get_env(__MODULE__, [])
    |> Keyword.get(key)
  end

  @image_extensions ~w[jpg png tiff webp]

  def is_image?(%{"url" => url}) do
    Enum.any?(@image_extensions, fn ext ->
      String.ends_with?(String.downcase(url), ".#{ext}")
    end)
  end
  def is_image?(_), do: false
end
