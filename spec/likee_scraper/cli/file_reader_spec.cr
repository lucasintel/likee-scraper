require "./../../spec_helper"

describe LikeeScraper::CLI::FileProcessor do
  describe ".call" do
    it "returns nil when file does not exist" do
      file_path = "/tmp/likeer-specs-#{Random.new.hex(4)}"
      result = LikeeScraper::CLI::FileProcessor.call(file_path)

      result.should be_nil
    end

    it "returns an empty array when the file is empty" do
      file = File.tempfile
      result = LikeeScraper::CLI::FileProcessor.call(file.path)

      result.should eq([] of String)
    end

    it "parses the file when file exist" do
      file = File.tempfile
      content =
        <<-FILE
        # Commented Line

        @username
        111

        222
        FILE

      File.write(file.path, content)

      result = LikeeScraper::CLI::FileProcessor.call(file.path)

      result.should eq(["@username", "111", "222"])
    end
  end
end
