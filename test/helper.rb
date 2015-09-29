$VERBOSE = true

require "cutest"
require "rack/test"
require_relative "../lib/tynn"

class Driver
  include Rack::Test::Methods

  attr_reader :app

  def initialize(app)
    @app = app
  end

  alias_method :res, :last_response
  alias_method :req, :last_request
end
