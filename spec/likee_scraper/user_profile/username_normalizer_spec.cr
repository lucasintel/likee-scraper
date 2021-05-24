require "../../spec_helper"

describe LikeeScraper::UsernameNormalizer do
  describe "#call" do
    it "returns early when the identifier is already the user_id" do
      subject = LikeeScraper::UsernameNormalizer.new("999")

      subject.call.should eq("999")
    end

    it "scrapes Likee website to find out the user_id" do
      WebMock
        .stub(:get, "https://likee.video/@111")
        .to_return(
          status: 200,
          body: <<-HTML
            {"userinfo":{"uid":"999","yyuid":"foo","type":0}[...]}
          HTML
        )

      subject = LikeeScraper::UsernameNormalizer.new("@111")

      subject.call.should eq("999")
    end

    it "returns nil when the user_id is not found in the page" do
      WebMock
        .stub(:get, "https://likee.video/@111")
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
        .stub(:get, "https://likee.video/@111")
        .to_return(status: 404, body: "")

      subject = LikeeScraper::UsernameNormalizer.new("@111")

      subject.call.should be_nil
    end

    it "sets Referer and User-Agent headers" do
      WebMock
        .stub(:get, "https://likee.video/@111")
        .with(
          headers: {
            "Referer"    => "https://google.com/",
            "User-Agent" => "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
          }
        )

      subject = LikeeScraper::UsernameNormalizer.new("@111")

      subject.call
    end
  end
end
