module Tynn::DefaultMatcher
  def default
    yield

    halt(res.finish)
  end
end
