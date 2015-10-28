class Tynn
  # Public: Adds extra matchers to Tynn.
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/matchers"
  #
  #   Tynn.plugin(Tynn::Matchers)
  #
  module Matchers
    module InstanceMethods
      # Public: A catch-all matcher. Always executes the given block.
      #
      # Examples
      #
      #   Tynn.define do
      #     authenticated? do
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

      # Public: Executes the given block if +key+ is present in +req.params+.
      #
      # key - Any object that responds to +to_s+.
      #
      # Examples
      #
      #   Tynn.define do
      #     param(:user) do |params|
      #       user = User.create(params)
      #
      #       # ...
      #     end
      #
      #     default do
      #       res.write("missing [user] param")
      #     end
      #   end
      #
      def param(key)
        if (v = req[key]) && !v.empty?
          yield(v)

          halt(res.finish)
        end
      end
    end
  end
end
