require "seg"
require_relative "request"
require_relative "response"

class Tynn
  module Base
    INBOX = "tynn.inbox".freeze # :nodoc:
    VARS = "tynn.vars".freeze # :nodoc:

    def initialize(code)
      @__code = code
      @tynn_inbox = {}
    end

    def env
      return @__env
    end

    def req
      return @__req
    end

    def res
      return @__res
    end

    def inbox
      return @tynn_inbox
    end

    def vars
      return env[VARS]
    end

    def default_headers
      return {}
    end

    def call(env, inbox = env.fetch(INBOX, {}))
      @__env = env
      @__req = Tynn::Request.new(env)
      @__res = Tynn::Response.new(default_headers)
      @__seg = Seg.new(env.fetch(Rack::PATH_INFO))
      @tynn_inbox = inbox

      catch(:halt) do
        instance_eval(&@__code)

        return @__res.finish
      end
    end

    def run(app, vars = {})
      path, script = env[Rack::PATH_INFO], env[Rack::SCRIPT_NAME]

      env[Rack::PATH_INFO] = @__seg.curr
      env[Rack::SCRIPT_NAME] = @__seg.prev
      env[VARS] = vars

      halt(app.call(env))
    ensure
      env[Rack::PATH_INFO], env[Rack::SCRIPT_NAME] = path, script
    end

    def halt(response)
      throw(:halt, response)
    end

    def match(arg)
      case arg
      when String then @__seg.consume(arg)
      when Symbol then @__seg.capture(arg, inbox)
      when true   then true
      else false
      end
    end

    def on(arg)
      if match(arg)
        yield

        halt(res.finish)
      end
    end

    def root?
      return @__seg.root?
    end

    def root
      if root?
        yield

        halt(res.finish)
      end
    end

    def get
      if root? && req.get?
        yield

        halt(res.finish)
      end
    end

    def put
      if root? && req.put?
        yield

        halt(res.finish)
      end
    end

    def post
      if root? && req.post?
        yield

        halt(res.finish)
      end
    end

    def patch
      if root? && req.patch?
        yield

        halt(res.finish)
      end
    end

    def delete
      if root? && req.delete?
        yield

        halt(res.finish)
      end
    end

    module ClassMethods
      def define(&code)
        @code = code
      end

      def use(_middleware, *args, &block)
        middleware << proc { |app| _middleware.new(app, *args, &block) }
      end

      def call(env) # :nodoc:
        return to_app.call(env)
      end

      def to_app # :nodoc:
        fail("Missing application handler. Try #{ self }.define") unless @code

        app = self.new(@code)

        if middleware.empty?
          return app
        else
          return middleware.reverse.inject(app) { |a, m| m.call(a) }
        end
      end

      def middleware # :nodoc:
        return @middleware ||= []
      end

      def reset! # :nodoc:
        @code = nil
        @middleware = []
      end
    end
  end
end
