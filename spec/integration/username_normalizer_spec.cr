require "../spec_helper"

LIKEE_OFFICIAL_ACCOUNT_USERNAME = "@Likee_USA"
LIKEE_OFFICIAL_ACCOUNT_ID       = "30007"

describe "User Normalizer" do
  it "fetches the user id" do
    WebMock.allow_net_connect = true

    user_id =
      LikeeScraper::UsernameNormalizer
        .new(LIKEE_OFFICIAL_ACCOUNT_USERNAME)
        .call

    user_id.should_not be_nil
    user_id.should eq(LIKEE_OFFICIAL_ACCOUNT_ID)
  end
end
