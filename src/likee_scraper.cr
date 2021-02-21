require "file_utils"
require "http/client"
require "likee"
require "log"
require "progress"
require "retriable"

require "./likee_scraper/**"

module LikeeScraper
  def self.download_user(username_or_id : String, fast_update = false) : Nil
    user_id = UsernameNormalizer.new(username_or_id).call

    if user_id.nil?
      Log.error { "🚩 User not found: #{username_or_id}" }
      return
    end

    VideoCollector.collect_each(user_id: user_id) do |video|
      downloaded = VideoDownloader.new(video).call

      if fast_update && !downloaded
        Log.info { "✅ User #{username_or_id} in sync!" }
        return
      end
    end
  end

  def self.download_users(users = [] of String, fast_update = false) : Nil
    Log.info { "\nDownloading #{users.size} profiles: #{users.join(' ')}." }

    users.each do |username_or_id|
      Log.info { "\nCollecting videos from profile #{username_or_id}." }
      download_user(username_or_id, fast_update: fast_update)
    end
  end
end
