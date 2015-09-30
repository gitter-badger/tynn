require "rack/test"

class Tynn
  class Test
    include Rack::Test::Methods

    def initialize(app = Tynn)
      @app = app
    end

    def app
      return @app
    end

    alias_method :res, :last_response
    alias_method :req, :last_request
  end
end
