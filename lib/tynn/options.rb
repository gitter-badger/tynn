module Tynn::Options
  def options
    if root? && req.options?
      yield

      halt(res.finish)
    end
  end
end
