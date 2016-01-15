# frozen_string_literal: true

class Tynn
  module NotFound
    # @private
    module InstanceMethods
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
