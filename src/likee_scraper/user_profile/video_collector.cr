module LikeeScraper
  # The `VideoCollector` module defines the interaction with the Likee API
  # to fetch videos from the user profile.
  module VideoCollector
    MAX_VIDEOS_PER_PAGE = 100

    # Yields each video from the user profile. It iterates through all pages
    # from the newest video to the oldest video.
    def self.collect_each(user_id : String, last_post_id : String = "")
      loop do
        collection = Utils.retry_on_connection_error do
          Likee.user_videos(
            user_id: user_id,
            last_post_id: last_post_id,
            limit: MAX_VIDEOS_PER_PAGE
          )
        end

        break if collection.empty?

        last_post_id = collection.last.id

        collection.each do |video|
          yield(video)
        end
      end
    end
  end
end
