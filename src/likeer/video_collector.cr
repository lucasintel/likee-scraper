require "./utils"

module Likeer
  # The `VideoCollector` module defines the interaction with the Likee API
  # to fetch videos from the user profile.
  module VideoCollector
    MAX_VIDEOS_PER_PAGE = 100

    Log = ::Log.for("VideoCollector")

    # Yields each video from the user profile. It iterates through all pages
    # from the newest video to the oldest video.
    def self.collect_each(uid : String, last_post_id : String = "")
      loop do
        Log.info { "API Call uid:#{uid} last_post_id:#{last_post_id}" }

        collection = Utils.retry_on_connection_error do
          Likee.get_user_video(
            uid: uid, last_post_id: last_post_id, count: MAX_VIDEOS_PER_PAGE
          )
        end

        break if collection.videos.empty?

        last_post_id = collection.last_post_id.to_s

        collection.videos.each do |video|
          yield(video)
        end
      end
    end
  end
end
