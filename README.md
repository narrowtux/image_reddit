# ImageReddit

ImageReddit is an image downloader that downloads all posts from the "Hot" pages
of all subreddits you tell it to.

This is useful if you want to feed a directory of nice images to your screensaver,
use changing desktop pictures, or need a bunch of images to mock up a website or
something.

## Installing:

`mix deps.get`

Configure your subreddits:

`config/config.exs`

```elixir
config :image_reddit, ImageReddit.Updater,
  subreddits: ~w[itookapicture pics],
  output_dir: "/path/to/images/"
```

Then just run `iex -S mix` to start the downloads.

Better configuration and standalone builds will come soon.
