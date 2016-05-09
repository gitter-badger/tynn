# frozen_string_literal: true

class Tynn
  class MiddlewareStack # :nodoc:
    attr_reader :middlewares

    def initialize
      @middlewares = []
    end

    def build(app)
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
