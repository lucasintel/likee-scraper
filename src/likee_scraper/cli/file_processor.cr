module LikeeScraper
  module CLI
    class FileProcessor
      INLINE_COMMENTS_REGEX = /\#.*$/

      def self.call(file : String) : Array(String)?
        return unless File.exists?(file)

        ids = [] of String

        File.each_line(file) do |line|
          next if line.empty?
          next if line.starts_with?(/\s/) || line.starts_with?("#")

          ids << line.gsub(INLINE_COMMENTS_REGEX, "").strip
        end

        ids
      end
    end
  end
end
