# frozen_string_literal: true

class Tynn
  # A simple helper class to simulate requests to the application.
  #
  #   require "tynn"
  #   require "tynn/test"
  #
  #   Tynn.define do
  #     root do
  #       res.write("Hei!")
  #     end
  #   end
  #
  #   app = Tynn::Test.new
  #   app.get("/")
  #
  #   app.res.status # => 200
  #   app.res.body   # => "Hei!"
  #
  class Test
    attr_reader :app # :nodoc:

    # Initializes a new Tynn::Test object.
    #
    #   class API < Tynn
    #   end
    #
    #   app = Tynn::Test.new(API)
    #   app.get("/user.json")
    #
    def initialize(app = Tynn)
      @app = app
    end

    # This module provides the Tynn::Test API methods. If the stand-alone
    # version is not preferred, this module can be integrated into the
    # testing environment. The following example uses Minitest:
    #
    #   class HomeTest < Minitest::Test
    #     include Tynn::Test::Methods
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
    module Methods
      # If a request has been issued, returns an instance of
      # Rack::Request[http://www.rubydoc.info/gems/rack/Rack/Request].
      # Otherwise, returns +nil+.
      #
      #   app = Tynn::Test.new
      #   app.get("/", { foo: "foo" }, { "HTTP_USER_AGENT" => "Tynn::Test" })
      #
      #   app.req.get?
      #   # => true
      #
      #   app.req.params["foo"]
      #   # => "foo"
      #
      #   app.req.env["HTTP_USER_AGENT"]
      #   # => "Tynn::Test"
      #
      def req
        @__req
      end

      # If a request has been issued, returns an instance of
      # Rack::MockResponse[http://www.rubydoc.info/gems/rack/Rack/MockResponse].
      # Otherwise, returns +nil+.
      #
      #   app = Tynn::Test.new
      #   app.get("/", name: "Jane")
      #
      #   app.res.status
      #   # => 200
      #
      #   app.res.body
      #   # => "Hello Jane!"
      #
      #   app.res["Content-Type"]
      #   # => "text/html"
      #
      def res
        @__res
      end

      # Issues a +GET+ request.
      #
      # [path]   A request path.
      # [params] A Hash of query/post parameters, a String request body,
      #          or +nil+.
      # [env]    A Hash of Rack environment values
      #
      #   app = Tynn::Test.new
      #   app.get("/search", name: "jane")
      #   app.get("/cart", {}, { "HTTPS" => "on" })
      #
      def get(path, params = {}, env = {})
        request(path, env.merge(method: "GET", params: params))
      end

      # Issues a +POST+ request. See #get for more information.
      #
      #   app = Tynn::Test.new
      #   app.post("/signup", username: "janedoe", password: "secret")
      #
      def post(path, params = {}, env = {})
        request(path, env.merge(method: "POST", params: params))
      end

      # Issues a +PUT+ request. See #get for more information.
      #
      #   app = Tynn::Test.new
      #   app.put("/users/1", username: "johndoe", name: "John")
      #
      def put(path, params = {}, env = {})
        request(path, env.merge(method: "PUT", params: params))
      end

      # Issues a +PATCH+ request. See #get for more information.
      #
      #   app = Tynn::Test.new
      #   app.patch("/users/1", username: "janedoe")
      #
      def patch(path, params = {}, env = {})
        request(path, env.merge(method: "PATCH", params: params))
      end

      # Issues a +DELETE+ request. See #get for more information.
      #
      #   app = Tynn::Test.new
      #   app.delete("/users/1")
      #
      def delete(path, params = {}, env = {})
        request(path, env.merge(method: "DELETE", params: params))
      end

      # Issues a +HEAD+ request. See #get for more information.
      #
      #   app = Tynn::Test.new
      #   app.head("/users/1")
      #
      def head(path, params = {}, env = {})
        request(path, env.merge(method: Rack::HEAD, params: params))
      end

      # Issues a +OPTIONS+ request. See #get for more information.
      #
      #   app = Tynn::Test.new
      #   app.options("/users")
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

    include Methods
  end
end
