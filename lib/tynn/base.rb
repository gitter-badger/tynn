# frozen_string_literal: true

require "syro"
require_relative "request"
require_relative "response"

class Tynn
  module Base
    # @private
    def self.setup(app)
      app.include(Syro::Deck::API)
    end

    module ClassMethods
      # Sets the application handler.
      #
      # @example
      #   class Users < Tynn
      #   end
      #
      #   Users.define do
      #     on(:id) do
      #       id = inbox[:id]
      #
      #       get do
      #         res.write("GET /users/#{ id }")
      #       end
      #
      #       post do
      #         res.write("POST /users/#{ id }")
      #       end
      #     end
      #   end
      #
      # @return [void]
      #
      def define(&block)
        @__app = middleware.inject(Syro.new(self, &block)) { |a, m| m.call(a) }
      end

      # Adds given Rack `middleware` to the stack.
      #
      # @param middleware A Rack middleware.
      # @param *args A list of arguments passed to the middleware initialization.
      # @param &block A block passed to the middleware initialization.
      #
      # @example
      #   require "rack/common_logger"
      #   require "rack/show_exceptions"
      #
      #   Tynn.use(Rack::CommonLogger)
      #   Tynn.use(Rack::ShowExceptions)
      #
      # @return [void]
      #
      # @see http://tynn.xyz/middleware.html
      #
      def use(middleware, *args, &block)
        self.middleware.unshift(Proc.new { |app| middleware.new(app, *args, &block) })
      end

      # @private
      def call(env)
        app.call(env)
      end

      # @private
      def middleware
        @__middleware ||= []
      end

      # @private
      def app
        @__app or raise("Application handler is missing. Try #{ self }.define { }")
      end

      # @private
      def reset!
        @__app = nil
        @__middleware = []
      end
    end

    # @private
    module InstanceMethods
      def request_class
        Tynn::Request
      end

      def response_class
        Tynn::Response
      end
    end
  end
end
