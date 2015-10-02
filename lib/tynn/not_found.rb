module Tynn::NotFound
  def call(env, inbox) # :nodoc:
    result = super(env, inbox)

    status, _, body = result

    if status == 404 && body.empty?
      not_found

      return res.finish
    else
      return result
    end
  end

  def not_found # :nodoc:
  end
end
