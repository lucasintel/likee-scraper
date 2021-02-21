module LikeeScraper
  module Connection
    CONNECT_TIMEOUT = 5.seconds
    READ_TIMEOUT    = 1.minute
    HTTPS           = "https"

    # Executes a GET request and yields the response. If the response is not
    # successful, raises `LikeeScraper::HTTPError`.
    def self.call(url : String, referer : String) : Nil
      uri = URI.parse(url)

      # Ensures that the resource will be downloaded over HTTPS.
      uri.scheme = HTTPS

      client = HTTP::Client.new(uri, tls: true)
      client.connect_timeout = CONNECT_TIMEOUT
      client.read_timeout = READ_TIMEOUT

      headers = HTTP::Headers{
        "User-Agent" => Likee::Utils.random_user_agent,
        "Referer"    => referer,
      }

      client.get(uri.to_s, headers: headers) do |response|
        raise HTTPError.new(response) unless response.success?

        yield(response)
      end
    end
  end
end
