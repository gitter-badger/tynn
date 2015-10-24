require "rack/test"

class Tynn
  # Public: A simple helper class to simulate requests to your application.
  #
  # Examples
  #
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
  #   200   == app.res.status # => true
  #   "hei" == app.res.body   # => true
  #
  # In order to use this plugin, you need to install
  # {rack-test}[https://rubygems.org/gems/rack-test].
  #
  class Test
    include Rack::Test::Methods

    # Internal: Returns the application class that handles the
    # mock requests. Required by Rack::Test::Methods.
    attr_reader :app

    # Public: Initializes a new Tynn::Test object.
    #
    # app - The application class to test (default: Tynn).
    #
    # Examples
    #
    #   class API < Tynn
    #   end
    #
    #   app = Tynn::Test.new(API)
    #   app.get("/json")
    #
    def initialize(app = Tynn)
      @app = app
    end

    alias_method :res, :last_response
    alias_method :req, :last_request
  end
end
