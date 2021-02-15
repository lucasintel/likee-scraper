require "likee"
require "log"

require "./likeer/*"

module Likeer
  # Iterates through the user - *uid* - profile and download all videos.
  def self.download_user_feed(uid : String)
    VideoCollector.collect_each(uid: uid) do |video|
      Downloader.download(video: video, directory: uid)
    end
  end
end
