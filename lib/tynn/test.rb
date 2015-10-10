require "rack/test"

# Tynn::Test is a simple helper class to test your application.
# It uses [rack-test][rack-test] helper methods to simulate requests.
#
#     require "tynn"
#     require "tynn/test"
#
#     Tynn.define do
#       root do
#         res.write("hei")
#       end
#     end
#
#     app = Tynn::Test.new
#     app.get("/")
#
#     200   == app.res.status # => true
#     "hei" == app.res.body   # => true
#
# **NOTE:** Tynn doesn't ship with [rack-test][rack-test]. In order to
# use this plugin, you need to install it first.
#
# [rack-test]: http://rubygems.org/gems/rack-test
#
class Tynn::Test
  include Rack::Test::Methods

  # Instantiates a new Tynn::Test object with the given `application` to test.
  #
  #     class API < Tynn
  #     end
  #
  #     app = Tynn::Test.new(API)
  #     app.get("/json")
  #
  def initialize(application = Tynn)
    @app = application
  end

  def app # :nodoc:
    return @app
  end

  alias_method :res, :last_response
  alias_method :req, :last_request
end
