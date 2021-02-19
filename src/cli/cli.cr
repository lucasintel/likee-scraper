require "option_parser"
require "../likee_scraper"
require "./cli/*"

module LikeeScraper
  module CLI
    def self.run : Nil
      fast_update = false
      usernames_or_user_ids = [] of String

      parsed = OptionParser.parse do |parser|
        parser.banner = "Usage: likeer [arguments]"

        parser.on(
          "-u @USERNAME⠀or⠀ID", "--user @USERNAME⠀or⠀ID",
          <<-TXT
          Download all videos (and their metadata) published by the given user.
          » Username: @Likee_USA (starts with a '@')
          » ID: 3007\n
          TXT
        ) do |value|
          usernames_or_user_ids << value.strip
        end

        parser.on(
          "-a FILE", "--batch-file FILE",
          <<-TXT
          File containing IDs or @usernames to download, one ID per line.
          Empty lines or lines starting with '#' are considered as comments
          and ignored.\n
          TXT
        ) do |value|
          extracted_ids = FileProcessor.call(value)

          if extracted_ids
            usernames_or_user_ids += extracted_ids
          else
            STDERR.puts "No such file or directory: #{value}"
            exit(1)
          end
        end

        parser.on(
          "-f", "--fast-update",
          <<-TXT
          Stop when encountering the first already-downloaded video.
          This flag is recommended when you use Likeer to update your personal
          archive.\n
          TXT
        ) do
          fast_update = true
        end

        parser.on("-v", "--version", "Show the version number and exit.") do
          puts VERSION
          exit(0)
        end

        parser.on("-h", "--help", "Show this help message and exit.") do
          puts parser
          exit(0)
        end

        parser.missing_option do |flag|
          STDERR.puts "ERROR: #{flag} flag expects a argument\n\n"
          STDERR.puts parser
          exit(1)
        end

        parser.invalid_option do |flag|
          STDERR.puts "ERROR: #{flag} is not a valid option.\n\n"
          STDERR.puts parser
          exit(1)
        end
      end

      if usernames_or_user_ids.empty?
        STDERR.puts "ERROR: Missing target user(s).\n\n"
        STDERR.puts parsed
        exit(1)
      end

      LikeeScraper
        .download_users(usernames_or_user_ids, fast_update: fast_update)
    end
  end
end

LikeeScraper::CLI.run
