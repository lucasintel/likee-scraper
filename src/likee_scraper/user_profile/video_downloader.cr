require "file_utils"
require "http/client"
require "../exceptions/*"

module LikeeScraper
  class VideoDownloader
    Log = ::Log.for("Downloader")

    PROGRESS_BAR_SIZE = 30
    MEGABYTE          = 1024**2

    def initialize(@video : Likee::Video)
      ensure_directory_exists
    end

    # Downloads a `Likee::Video`. The video is initially saved to a temporary
    # file, then it's moved to its definitive location.
    def call : Bool
      File.write(metadata_destination, @video.to_pretty_json)

      if File.exists?(destination)
        Log.info { "#{@video.creator_nickname} — #{@video.id}.mp4; skipping" }
        return false
      end

      Utils.retry_on_connection_error do
        HTTP::Client.get(@video.secure_url, headers: headers) do |response|
          raise HTTPError.new(response) unless response.success?

          file_size = response.headers["Content-Length"].to_u64 { 0_u64 }

          File.open(temp_destination, "w") do |file|
            buffer = uninitialized UInt8[4096]
            progress = 0_u64

            while (len = response.body_io.read(buffer.to_slice).to_i32) > 0
              file.write(buffer.to_slice[0, len])
              progress &+= len
              print_progress(file_size, progress)
            end
          end
        end
      end

      FileUtils.mv(temp_destination, destination)

      true
    rescue IO::TimeoutError | HTTPError
      Log.error { "Retries exausted: #{@video.secure_url}; skipping" }
      true
    end

    private def print_progress(file_size : UInt64, progress : UInt64) : Nil
      percent = progress / file_size

      bar_completed = (PROGRESS_BAR_SIZE * percent).to_i
      bar_not_completed = (PROGRESS_BAR_SIZE - bar_completed).to_i

      bar = String.build do |str|
        str << "["
        str << "=" * bar_completed
        str << " " * bar_not_completed
        str << "]"
      end

      formatted_progress = "%5.1f MB" % (progress / MEGABYTE)
      formatted_percent = "%4.f%%" % (percent * 100)

      template = "\r#{@video.creator_nickname} — #{@video.id}.mp4 " \
                 "#{bar} #{formatted_progress} #{formatted_percent}"

      STDOUT.flush
      STDOUT.print(template)
      STDOUT.flush
      STDOUT.print("\n") if file_size == progress
    end

    private def destination : String
      File.expand_path("#{@video.filename}.mp4", directory)
    end

    private def metadata_destination : String
      File.expand_path("#{@video.filename}.json", directory)
    end

    private def temp_destination : String
      "#{destination}.temp"
    end

    # For now, the directory always corresponds to the creator id.
    private def directory : String
      @video.creator_id
    end

    private def headers : HTTP::Headers
      HTTP::Headers{
        "User-Agent" => Likee::Utils.random_user_agent,
        "Referer"    => build_referer,
      }
    end

    private def build_referer : String
      "https://likee.video/@#{@video.creator_username}/video/#{@video.id}"
    end

    private def ensure_directory_exists : Nil
      return if Dir.exists?(directory)

      Dir.mkdir(directory)
    end
  end
end
