module LikeeScraper
  private struct LikeeLogger < Log::StaticFormatter
    def run : IO
      message
    end
  end

  Log.setup("*", backend: Log::IOBackend.new(formatter: LikeeLogger))
end
