class Tynn
  # Public: Adds method for HTTP's +HEAD+ and +OPTIONS+.
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
      # Public: Executes the given block if the request method is +HEAD+.
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

      # Public: Executes the given block if the request method is +OPTIONS+.
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
