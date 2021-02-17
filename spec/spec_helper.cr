require "spec"
require "webmock"

require "../src/likee_scraper"

def mocked_profile_feed_page_1
  File.read("#{mocks_path}/profile_feed_page_1.json")
end

def mocked_profile_feed_page_2
  File.read("#{mocks_path}/profile_feed_page_2.json")
end

def mocked_profile_feed_page_3
  File.read("#{mocks_path}/profile_feed_page_3.json")
end

def mocks_path : String
  File.expand_path("../mocks", __FILE__)
end
