module Likee
  struct Video
    # Returns the filename without the extension.
    def filename : String
      formatted_timestamp = uploaded_at.to_utc.to_s("%Y-%m-%d %T")
      "#{formatted_timestamp} - #{id}"
    end

    # Returns the HTTPs download url.
    # Ensures that the client downloads the `Video` over HTTPs.
    def secure_url : String
      return download_url unless download_url.starts_with?("http://")

      download_url.sub(/^http:/, "https:")
    end
  end
end
