require "commander"

require "../likee_scrapper"

module LikeeScraper
  # TODO: Refactor
  module CLI
    def self.config
      Commander::Command.new do |handler|
        handler.use = "likeer"
        handler.long = "download videos and their metadata from Likee."

        handler.flags.add do |flag|
          flag.name = "fast update"
          flag.short = "-f"
          flag.long = "--fast-update"
          flag.default = true
          flag.description = "Stop when encountering the first already-downloaded video."
        end

        handler.commands.add do |cmd|
          cmd.use = "store <uid>"
          cmd.short = "Download videos from the user feed."
          cmd.long = cmd.short
          cmd.run do |_options, arguments|
            unless uid = arguments.first
              puts "Missing <uid> argument."
              next
            end

            Log.info { "Likeer is running (v#{VERSION})" }

            elapsed_time = Time.measure do
              LikeeScrapper.download_user_feed(uid: uid)
            end

            Log.info { "Finished in #{elapsed_time.to_i} seconds" }
          end
        end

        handler.run do |_options, _arguments|
          puts handler.help
        end
      end
    end

    def self.run(argv)
      Commander.run(config, ARGV)
    end
  end
end
