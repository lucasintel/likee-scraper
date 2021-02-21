require "spec"
require "webmock"

require "../src/likee_scraper"

# Clears all Webmock stubs and sets `Webmock.allow_net_connect` to false.
Spec.before_each &->WebMock.reset

TEMPDIR_PATH = File.join(Dir.tempdir, "likeer-spec-#{Random.new.hex(4)}")

def read_from_tempdir(filename : String) : String
  path = File.expand_path(filename, tempdir.path)
  File.read(path)
end

def tempdir : Dir
  Dir.mkdir_p(TEMPDIR_PATH) unless Dir.exists?(TEMPDIR_PATH)

  Dir.open(TEMPDIR_PATH)
end

def load_fixture(name : String?) : String
  return "" unless name

  File.read("#{fixtures_path}/#{name}.json")
end

def fixtures_path : String
  File.expand_path("../fixtures", __FILE__)
end
