require "../../spec_helper"

describe LikeeScraper::VideoDownloader do
  describe "#call" do
    it "persists the given Likee::Video and its metadata" do
      video = Likee::Video.from_json(load_fixture("video"))
      directory = tempdir.path

      WebMock
        .stub(:get, "https://video.like.video/asia_live/7h4/M01/C5/9B/bfsbAF6ynouESl7_AAAAAEUuPaU099.mp4?crc=3552166534&type=5&i=04f146a0012f1ba21c42")
        .to_return(status: 200, body_io: IO::Memory.new("Fake mp4!"))

      subject = LikeeScraper::VideoDownloader.new(video, directory)
      subject.call

      (tempdir.entries.includes?("2020-05-19 03:02:02 - 6828385203296171312.json")).should be_true
      (tempdir.entries.includes?("2020-05-19 03:02:02 - 6828385203296171312.mp4")).should be_true

      metadata_file = read_from_tempdir("2020-05-19 03:02:02 - 6828385203296171312.json")
      video_file = read_from_tempdir("2020-05-19 03:02:02 - 6828385203296171312.mp4")

      metadata_file.should eq(video.to_pretty_json)
      video_file.should eq("Fake mp4!")
    end
  end
end
