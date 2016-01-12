# frozen_string_literal: true

class Tynn
  # A simple helper class to simulate requests to your application.
  #
  # @example
  #   require "tynn"
  #   require "tynn/test"
  #
  #   Tynn.define do
  #     root do
  #       res.write("hei")
  #     end
  #   end
  #
  #   app = Tynn::Test.new
  #   app.get("/")
  #
  #   app.res.status # => 200
  #   app.res.body   # => "hei"
  #
  # @see http://tynn.xyz/testing.html
  #
  class Test
    # @return [Tynn] the application class that handles the mock requests.
    attr_reader :app

    # Initializes a new Tynn::Test object.
    #
    # @param [Tynn] app The application class to test
    #
    # @example
    #   class API < Tynn
    #   end
    #
    #   app = Tynn::Test.new(API)
    #   app.get("/json")
    #
    def initialize(app = Tynn)
      @app = app
    end

    # This module provides the {Tynn::Test} API methods. If you don't
    # like the stand-alone version, you can integrate this module to your
    # preferred testing environment.
    #
    # @example Using Minitest
    #   class HomeTest < Minitest::Test
    #     include Tynn::Test::InstanceMethods
    #
    #     def app
    #       return Tynn
    #     end
    #
    #     def test_home
    #       get("/")
    #
    #       assert_equal 200, res.status
    #     end
    #   end
    #
    module InstanceMethods
      # Returns the current request object.
      #
      # @example
      #   app = Tynn::Test.new
      #   app.get("/", {}, { "HTTP_USER_AGENT" => "Tynn::Test" })
      #
      #   app.req.get?
      #   # => true
      #
      #   app.req.env["HTTP_USER_AGENT"]
      #   # => "Tynn::Test"
      #
      # @return [Rack::Request, nil] an instance of `Rack::Request`
      #   or `nil` if no requests have been issued yet.
      #
      # @see http://www.rubydoc.info/gems/rack/Rack/Request
      #
      def req
        return @__req
      end

      # Returns the current response object.
      #
      # @example
      #   app = Tynn::Test.new
      #   app.get("/", name: "alice")
      #
      #   app.res.status
      #   # => 200
      #
      #   app.res.body
      #   # => "Hello alice!"
      #
      # @return [Rack::MockResponse, nil] an instance of `Rack::MockResponse`
      #   or `nil` if no requests have been issued yet.
      #
      # @see http://www.rubydoc.info/gems/rack/Rack/MockResponse
      #
      def res
        return @__res
      end

      # Issues a `GET` request.
      #
      # @param [String] path A request path
      # @param [Hash, String, nil] params A Hash of query/post parameters,
      #   a `String` request body, or `nil`
      # @param [Hash] env A Hash of Rack environment values
      #
      # @example
      #   app = Tynn::Test.new
      #   app.get("/search", name: "alice")
      #
      # @return [void]
      #
      def get(path, params = {}, env = {})
        request(path, env.merge(method: "GET", params: params))
      end

      # Issues a `POST` request.
      #
      # @param (see #get)
      #
      # @example
      #   app = Tynn::Test.new
      #   app.post("/signup", username: "alice", password: "secret")
      #
      # @return [void]
      #
      def post(path, params = {}, env = {})
        request(path, env.merge(method: "POST", params: params))
      end

      # Issues a `PUT` request.
      #
      # @param (see #get)
      #
      # @example
      #   app = Tynn::Test.new
      #   app.put("/users/1", username: "bob", name: "Bob")
      #
      # @return [void]
      #
      def put(path, params = {}, env = {})
        request(path, env.merge(method: "PUT", params: params))
      end

      # Issues a `PATCH` request.
      #
      # @param (see #get)
      #
      # @example
      #   app = Tynn::Test.new
      #   app.patch("/users/1", username: "alice")
      #
      # @return [void]
      #
      def patch(path, params = {}, env = {})
        request(path, env.merge(method: "PATCH", params: params))
      end

      # Issues a `DELETE` request.
      #
      # @param (see #get)
      #
      # @example
      #   app = Tynn::Test.new
      #   app.delete("/users/1")
      #
      # @return [void]
      #
      def delete(path, params = {}, env = {})
        request(path, env.merge(method: "DELETE", params: params))
      end

      # Issues a `HEAD` request.
      #
      # @param (see #get)
      #
      # @example
      #   app = Tynn::Test.new
      #   app.head("/users/1")
      #
      # @return [void]
      #
      def head(path, params = {}, env = {})
        request(path, env.merge(method: Rack::HEAD, params: params))
      end

      # Issues a `OPTIONS` request.
      #
      # @param (see #get)
      #
      # @example
      #   app = Tynn::Test.new
      #   app.options("/users")
      #
      # @return [void]
      #
      def options(path, params = {}, env = {})
        request(path, env.merge(method: "OPTIONS", params: params))
      end

      private

      def request(path, opts = {})
        @__req = Rack::Request.new(Rack::MockRequest.env_for(path, opts))
        @__res = Rack::MockResponse.new(*app.call(@__req.env))
      end
    end

    include InstanceMethods
  end
end
