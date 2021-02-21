require "./../../spec_helper"

describe LikeeScraper::HTTPError do
  describe "#message" do
    it "returns a friendly message for the HTTP error" do
      status = HTTP::Status.new(429)
      response = HTTP::Client::Response.new(status)

      subject = LikeeScraper::HTTPError.new(response)

      subject.message.should eq("HTTP status code 429: Too Many Requests")
    end
  end

  describe "#status" do
    it "returns the underlying HTTP status" do
      status = HTTP::Status.new(429)
      response = HTTP::Client::Response.new(status)

      subject = LikeeScraper::HTTPError.new(response)

      subject.status.should eq(status)
    end
  end
end
