require "spec"
require "webmock"

require "../src/likee_scraper"

# Clears all Webmock stubs and sets `Webmock.allow_net_connect` to false.
Spec.before_each &->WebMock.reset

def load_fixture(name : String?)
  return "" unless name

  File.read("#{fixtures_path}/#{name}.json")
end

def fixtures_path : String
  File.expand_path("../fixtures", __FILE__)
end
