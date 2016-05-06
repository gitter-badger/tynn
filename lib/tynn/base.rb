# frozen_string_literal: true

require "syro"
require_relative "request"
require_relative "response"

class Tynn
  module Base
    def self.setup(app) # :nodoc:
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
        self.middleware.unshift(proc { |app| middleware.new(app, *args, &block) })
      end

      def call(env) # :nodoc:
        app.call(env)
      end

      def middleware # :nodoc:
        @__middleware ||= []
      end

      def app # :nodoc:
        @__app or raise("Application handler is missing. Try #{ self }.define { }")
      end

      def reset! # :nodoc:
        @__app = nil
        @__middleware = []
      end
    end

    module InstanceMethods # :nodoc:
      def request_class
        Tynn::Request
      end

      def response_class
        Tynn::Response
      end
    end
  end
end
