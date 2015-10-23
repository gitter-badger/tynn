class Tynn
  # Adds extra matchers to Tynn.
  #
  # ```
  # require "tynn"
  # require "tynn/matchers"
  #
  # Tynn.helpers(Tynn::Matchers)
  # ```
  #
  module Matchers
    module InstanceMethods
      # A catch-all matcher.
      #
      # ```
      # Tynn.define do
      #   authenticated? do
      #     # ...
      #   end
      #
      #   default do # on true
      #     # ...
      #   end
      # end
      # ```
      #
      # :call-seq: default(&block)
      #
      def default
        yield

        halt(res.finish)
      end

      # Match if the given `key` is present in `req.params`.
      #
      # ```
      # Tynn.define do
      #   param(:user) do |params|
      #     user = User.create(params)
      #
      #     # ...
      #   end
      #
      #   default do
      #     res.write("missing user param")
      #   end
      # end
      # ```
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
