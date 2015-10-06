module Tynn::AllMethods
  def head
    if root? && req.head?
      yield

      halt(res.finish)
    end
  end

  def options
    if root? && req.options?
      yield

      halt(res.finish)
    end
  end
end
