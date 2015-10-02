require "rack/test"

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
end
