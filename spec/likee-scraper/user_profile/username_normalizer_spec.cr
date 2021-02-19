require "../../spec_helper"

describe LikeeScraper::UsernameNormalizer do
  describe "#call" do
    it "returns early when the identifier is already the user_id" do
      subject = LikeeScraper::UsernameNormalizer.new("999")

      subject.call.should eq("999")
    end

    it "scrapes Likee website to find out the user_id" do
      WebMock
        .stub(:get, "https://likee.video/user/@111/amp")
        .to_return(
          status: 200,
          body: <<-HTML
            <meta property="al:android:url" content="likevideo://profile?uid=999">
          HTML
        )

      subject = LikeeScraper::UsernameNormalizer.new("@111")

      subject.call.should eq("999")
    end

    it "returns nil when the user_id is not found in the page" do
      WebMock
        .stub(:get, "https://likee.video/user/@111/amp")
        .to_return(
          status: 200,
          body: <<-HTML
            <strong>Nah!</strong>>
          HTML
        )

      subject = LikeeScraper::UsernameNormalizer.new("@111")

      subject.call.should be_nil
    end

    it "returns nil when the HTTP request is not successful" do
      WebMock
        .stub(:get, "https://likee.video/user/@111/amp")
        .to_return(status: 404, body: "")

      subject = LikeeScraper::UsernameNormalizer.new("@111")

      subject.call.should be_nil
    end
  end
end
