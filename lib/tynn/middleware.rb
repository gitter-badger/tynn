# frozen_string_literal: true

class Tynn
  class Middleware
    module ClassMethods
      def define(&block) # :nodoc:
        @__app = middleware.build_app(super)
      end

      # Adds given Rack +middleware+ to the stack.
      #
      # [middleware] A Rack middleware.
      # [*args]      A list of arguments passed to the middleware initialization.
      # [&block]     A block passed to the middleware initialization.
      #
      #   require "rack/common_logger"
      #   require "rack/show_exceptions"
      #
      #   Tynn.use(Rack::CommonLogger)
      #   Tynn.use(Rack::ShowExceptions)
      #
      def use(middleware, *args, &block)
        self.middleware.use(middleware, *args, &block)
      end

      def middleware
        @__middleware ||= Stack.new
      end
    end

    class Stack
      attr_reader :middlewares

      def initialize
        @middlewares = []
      end

      def build_app(app)
        middlewares.freeze.reverse.inject(app) { |a, e| e.call(a) }
      end

      def use(middleware, *args, &block)
        middlewares.push(build_middleware(middleware, *args, &block))
      end

      def unshift(middleware, *args, &block)
        middlewares.unshift(build_middleware(middleware, *args, &block))
      end

      private

      def build_middleware(middleware, *args, &block)
        proc { |app| middleware.new(app, *args, &block) }
      end
    end
  end
end
