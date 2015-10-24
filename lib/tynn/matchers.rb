class Tynn
  # Public: Adds extra matchers to Tynn.
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/matchers"
  #
  #   Tynn.helpers(Tynn::Matchers)
  #
  module Matchers
    module InstanceMethods
      # Public: A catch-all matcher.
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
      # :call-seq: default(&block)
      #
      def default
        yield

        halt(res.finish)
      end

      # Public: Match if the given +key+ is present in +req.params+.
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
      #       res.write("missing user param")
      #     end
      #   end
      #
      # :call-seq: param(key, &block)
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
