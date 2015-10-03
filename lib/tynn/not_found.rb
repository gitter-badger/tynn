module Tynn::NotFound
  def call(env, inbox) # :nodoc:
    result = super(env, inbox)

    if result[0] == 404 && result[2].empty?
      not_found

      return res.finish
    else
      return result
    end
  end

  def not_found # :nodoc:
  end
end
