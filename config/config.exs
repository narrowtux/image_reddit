# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :image_reddit, ImageReddit.Updater,
  subreddits: ["spaceporn", "earthporn", "itookapicture"],
  output_dir: "/Users/tux/Pictures/reddit"

config :quantum, :your_app,
  cron: [
    {"*/15 * * * *", {ImageReddit.Updater, :update_all, []}},
    {"@reboot", {ImageReddit.Updater, :update_all, []}}
  ]
