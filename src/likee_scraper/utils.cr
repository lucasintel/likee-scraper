require "retriable"

module LikeeScraper
  # The `Utils` module defines multiple helpers.
  module Utils
    # Retries the *&block* when a connection error or a Likee API error occurs.
    def self.retry_on_connection_error(&block)
      on_retry_callback =
        ->(_ex : Exception, attempt : Int32, _elapsed_time : Time::Span, _next_interval : Time::Span) do
          Log.error {
            "An error occoured while fetching posts; retring (#{attempt}/5)..."
          }
        end

      Retriable.retry(
        on: {IO::TimeoutError, Errno::ECONNRESET, Likee::Client::ClientError},
        on_retry: on_retry_callback,
        intervals: Array.new(5, 2.seconds)
      ) do
        yield
      end
    end
  end
end
