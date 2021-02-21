module LikeeScraper
  class UsernameNormalizer
    BASE_URL      = URI.parse("https://likee.video")
    USER_ID_REGEX = /likevideo\:\/\/profile\?uid\=(?<user_id>\d+)/
    USER_AGENT    = "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"

    @client : HTTP::Client

    def initialize(@identifier : String)
      @client = build_client
    end

    def call : String?
      # The identifier is already the user_id.
      return @identifier unless @identifier.starts_with?("@")

      response = @client.get("/user/#{@identifier}/amp")
      return unless response.success?

      if match = response.body.match(USER_ID_REGEX)
        match["user_id"]
      end
    end

    private def build_client : HTTP::Client
      conn = HTTP::Client.new(BASE_URL, tls: true)

      conn.connect_timeout = 2.seconds
      conn.write_timeout = 2.seconds
      conn.read_timeout = 5.seconds

      conn.before_request do |request|
        request.headers.merge!(headers)
      end

      conn
    end

    private def headers : HTTP::Headers
      HTTP::Headers{
        "Referer"    => "https://google.com/",
        "User-Agent" => USER_AGENT,
      }
    end
  end
end
