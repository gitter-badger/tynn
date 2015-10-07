require "rack/test"

# Tynn::Test is a simple helper class to test your application.
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
# use this plugin, you need to install it.
#
# [rack-test]: http://rubygems.org/gems/rack-test
#
class Tynn::Test
  include Rack::Test::Methods

  def initialize(app = Tynn) # :nodoc:
    @app = app
  end

  def app # :nodoc:
    return @app
  end

  alias_method :res, :last_response
  alias_method :req, :last_request

  ##
  # :method: res
  # :call-seq: res
  #
  # Alias for `last_response`.

  ##
  # :method: req
  # :call-seq: req
  #
  # Alias for `last_request`.
end
