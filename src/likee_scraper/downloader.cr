require "file_utils"
require "http/client"

require "./utils"

module LikeeScraper
  class Downloader
    Log = ::Log.for("Downloader")

    # Instantiates a `Downloader` and call `#download`.
    def self.download(video : Likee::Video, directory : String) : Bool
      new(video, directory).download
    end

    def initialize(@video : Likee::Video, @directory : String)
      ensure_directory_exists
    end

    # Downloads a `Likee::Video`. The video is initially saved to a temporary
    # file, then it's moved to its definitive location.
    def download : Bool
      if File.exists?(filename)
        Log.info { "#{@video.id} already archived; skipping" }
        return true
      end

      begin
        Utils.retry_on_connection_error do
          HTTP::Client.get(@video.download_url, headers: headers) do |response|
            raise Likee::Client::ClientError.new(response.status) unless response.success?

            File.write(temp_filename, response.body_io)
          end
        end
      rescue ex
        Log.error { "Retries exausted: #{@video.download_url}; skipping" }
        return false
      end

      FileUtils.mv(temp_filename, filename)

      Log.info { "#{@video.id} has been successfully archived" }

      true
    end

    private def filename : String
      formatted_timestamp = @video.uploaded_at.to_utc.to_s("%Y-%m-%d %T")
      template = "#{formatted_timestamp} - #{@video.id}.mp4"

      File.expand_path(template, @directory)
    end

    private def temp_filename : String
      "#{filename}.temp"
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
      return if Dir.exists?(@directory)

      Log.info { "Creating directory #{@directory}" }

      Dir.mkdir_p(@directory)
    end
  end
end
