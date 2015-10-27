class Tynn
  # Public: Adds extra method matchers to Tynn.
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/all_methods"
  #
  #   Tynn.helpers(Tynn::AllMethods)
  #
  module AllMethods
    module InstanceMethods
      # Public: Yields if request method is +HEAD+.
      #
      # Examples
      #
      #   Tynn.define do
      #     head do
      #       res.status = 201
      #     end
      #   end
      #
      def head
        if root? && req.head?
          yield

          halt(res.finish)
        end
      end

      # Public: Yields if request method is +OPTIONS+.
      #
      # Examples
      #
      #   Tynn.define do
      #     options do
      #       res.status = 405
      #     end
      #   end
      #
      def options
        if root? && req.options?
          yield

          halt(res.finish)
        end
      end
    end
  end
end
