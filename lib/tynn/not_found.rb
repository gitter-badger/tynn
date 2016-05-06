# frozen_string_literal: true

class Tynn
  module NotFound
    module InstanceMethods # :nodoc:
      def call(*)
        result = super

        return result unless result[0] == 404 && result[2].empty?

        not_found

        res.finish
      end

      def not_found
      end
    end
  end
end
