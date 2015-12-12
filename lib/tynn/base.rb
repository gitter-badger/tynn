require "syro"
require_relative "request"
require_relative "response"

class Tynn
  module Base
    def self.setup(app)
      app.include(Syro::Deck::API)
    end

    module ClassMethods
      # Public: Sets the application handler.
      #
      # Examples
      #
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
      def define(&block)
        @__app = middleware.inject(Syro.new(self, &block)) { |a, m| m.call(a) }
      end

      # Public: Adds given Rack +middleware+ to the stack.
      #
      # Examples
      #
      #   require "rack/common_logger"
      #   require "rack/show_exceptions"
      #
      #   Tynn.use(Rack::CommonLogger)
      #   Tynn.use(Rack::ShowExceptions)
      #
      def use(middleware, *args, &block)
        self.middleware.unshift(Proc.new { |app| middleware.new(app, *args, &block) })
      end

      def middleware # :nodoc:
        return @__middleware ||= []
      end

      def call(env) # :nodoc:
        return @__app.call(env)
      end
    end

    module InstanceMethods
      def request_class # :nodoc:
        return Tynn::Request
      end

      def response_class # :nodoc:
        return Tynn::Response
      end
    end
  end
end
