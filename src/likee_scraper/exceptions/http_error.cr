require "http/client"

module LikeeScraper
  # The `HTTPError` exception is raised when the HTTP status is not between
  # 200 and 299.
  class HTTPError < Exception
    delegate :status, to: :response

    getter response : HTTP::Client::Response

    def initialize(@response)
    end

    def message : String
      "HTTP status code #{status.code}: #{status.description}"
    end
  end
end
