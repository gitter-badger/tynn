class Tynn
  module DefaultMatcher
    def default
      yield

      halt(res.finish)
    end
  end
end
