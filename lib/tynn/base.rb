# Copyright (c) 2015 Michel Martens
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require "seg"
require_relative "request"
require_relative "response"

class Tynn
  module Base
    VARS = "tynn.vars".freeze # :nodoc:

    def initialize(code)
      @__code = code
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

    def vars
      return env[VARS]
    end

    def default_headers
      return {}
    end

    def call(env)
      @__env = env
      @__req = Tynn::Request.new(env)
      @__res = Tynn::Response.new(default_headers)
      @__seg = Seg.new(env.fetch(Rack::PATH_INFO))
      @__inbox = {}

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
      when Symbol then @__seg.capture(arg, @__inbox)
      when true   then true
      else false
      end
    end

    def on(arg)
      if match(arg)
        yield(@__inbox[arg])

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
