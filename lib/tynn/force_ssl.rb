module Tynn::ForceSSL
  def self.setup(app) # :nodoc:
    app.use(Middleware)
  end

  class Middleware
    HTTPS_LOCATION = "https://%s%s".freeze

    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      if request.ssl?
        return @app.call(env)
      end

      headers = {
        "Content-Type" => "text/html",
        "Location" => https_location(request)
      }

      return [301, headers, []]
    end

    private

    def https_location(request)
      return sprintf(HTTPS_LOCATION, request.host, request.fullpath)
    end
  end
end
