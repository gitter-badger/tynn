class Tynn
  module NotFound
    def call(*) # :nodoc:
      result = super

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
end
