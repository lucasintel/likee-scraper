module LikeeScraper
  class VideoDownloader
    Log = ::Log.for("Downloader")

    def initialize(@video : Likee::Video, @directory : String? = nil)
    end

    # Downloads a `Likee::Video`. The video is initially saved to a temporary
    # destination, then it's moved to its definitive destination.
    def call : Bool
      ensure_destination_directory_exists

      File.write(metadata_destination, @video.to_pretty_json)

      if File.exists?(destination)
        Log.info { " + #{@video.creator_nickname} — #{@video.id}.mp4; exists" }
        return false
      end

      Utils.retry_on_connection_error do
        Connection.call(@video.download_url, referer: referer) do |response|
          file_size = response.headers.fetch("Content-Length", 1).to_u64
          progress = build_progress_bar(file_size)

          File.open(temp_destination, "w") do |file|
            buffer = uninitialized UInt8[4096]

            while (len = response.body_io.read(buffer.to_slice).to_i32) > 0
              file.write(buffer.to_slice[0, len])
              progress.tick(len)
            end
          end
        end
      end

      FileUtils.mv(temp_destination, destination)

      true
    rescue IO::TimeoutError | HTTPError
      Log.error { " ! Retries exausted: #{@video.download_url}; skipping" }
      true
    end

    private def ensure_destination_directory_exists : Nil
      Dir.exists?(directory) || Dir.mkdir(directory)
    end

    # For now, the directory is always equal to the creator id.
    private def directory : String
      @directory || @video.creator_id
    end

    private def metadata_destination : String
      File.expand_path("#{filename}.json", directory)
    end

    private def destination : String
      File.expand_path("#{filename}.mp4", directory)
    end

    private def temp_destination : String
      "#{destination}.temp"
    end

    private def filename : String
      @filename ||= begin
        formatted_timestamp = @video.uploaded_at.to_utc.to_s("%Y-%m-%d %T")
        "#{formatted_timestamp} - #{@video.id}"
      end
    end

    private def referer : String
      "https://likee.video/@#{@video.creator_username}/video/#{@video.id}"
    end

    private def build_progress_bar(total : UInt64) : Progress
      progress = Progress.new(
        template: " + {label} {bar} {step} {percent}",
        label: "#{@video.creator_nickname} - #{@video.id}",
        total: total,
        width: 30,
      )

      progress.init
      progress
    end
  end
end
