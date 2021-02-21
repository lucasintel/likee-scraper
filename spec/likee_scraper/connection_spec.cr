require "../spec_helper"

describe LikeeScraper::Connection do
  describe "#call" do
    it "ensures that the resource will be downloaded over HTTPS" do
      WebMock.stub(:get, "https://likee.com")

      LikeeScraper::Connection
        .call("https://likee.com", "https://google.com") { }
    end

    it "sets the referer" do
      WebMock
        .stub(:get, "https://likee.com")
        .with(headers: {"Referer" => "https://google.com"})

      LikeeScraper::Connection
        .call("https://likee.com", "https://google.com") { }
    end

    it "raises HTTPError when response is not successful" do
      WebMock
        .stub(:get, "https://likee.com")
        .to_return(status: 500)

      expect_raises(LikeeScraper::HTTPError) do
        LikeeScraper::Connection
          .call("https://likee.com", "https://google.com") { }
      end
    end
  end
end
