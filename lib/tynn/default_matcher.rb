class Tynn
  module DefaultMatcher
    module InstanceMethods
      # Public: A catch-all matcher. Always executes the given block.
      #
      # Examples
      #
      #   Tynn.define do
      #     get do
      #       # ...
      #     end
      #
      #     default do # on true
      #       # ...
      #     end
      #   end
      #
      def default
        yield

        halt(res.finish)
      end
    end
  end
end
