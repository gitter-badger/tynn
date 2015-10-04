require "seg"
require_relative "request"
require_relative "response"

class Tynn
  module Base
    INBOX = "tynn.inbox".freeze # :nodoc:
    VARS = "tynn.vars".freeze # :nodoc:

    def initialize(code)
      @tynn_code = code
      @tynn_inbox = {}
    end

    def env
      return @tynn_env
    end

    def req
      return @tynn_req
    end

    def res
      return @tynn_res
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
      @tynn_env = env
      @tynn_req = Tynn::Request.new(env)
      @tynn_res = Tynn::Response.new(default_headers)
      @tynn_path = Seg.new(env.fetch(Rack::PATH_INFO))
      @tynn_inbox = inbox

      catch(:halt) do
        instance_eval(&@tynn_code)

        return @tynn_res.finish
      end
    end

    def run(app, vars = {})
      path, script = env[Rack::PATH_INFO], env[Rack::SCRIPT_NAME]

      env[Rack::PATH_INFO] = @tynn_path.curr
      env[Rack::SCRIPT_NAME] = @tynn_path.prev
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
      when String then @tynn_path.consume(arg)
      when Symbol then @tynn_path.capture(arg, inbox)
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
      return @tynn_path.root?
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
