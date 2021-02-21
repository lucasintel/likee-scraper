module LikeeScraper
  # The `Utils` module defines multiple helpers.
  module Utils
    # Retries the *&block* when a connection error or a Likee API error occurs.
    def self.retry_on_connection_error(&block)
      on_retry_callback =
        ->(_ex : Exception, attempt : Int32, _elapsed_time : Time::Span, _next_interval : Time::Span) do
          Log.error { "An error occoured while executing request; retring (#{attempt}/5)" }
        end

      Retriable.retry(
        on: {
          IO::TimeoutError,
          OpenSSL::SSL::Error,
          Likee::RequestFailedError,
          Likee::APIError,
          HTTPError,
        },
        on_retry: on_retry_callback,
        intervals: Array.new(5, 5.seconds)
      ) do
        yield
      end
    end
  end
end
