class Tynn
  module ForceSSL
    def self.setup(app) # :nodoc:
      app.use(Tynn::ForceSSLMiddleware)
    end
  end

  class ForceSSLMiddleware # :nodoc:
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      if request.ssl?
        return @app.call(env)
      else
        return [301, redirect_headers(request), []]
      end
    end

    private

    def redirect_headers(request)
      return { "Location" => https_location(request) }
    end

    HTTPS_LOCATION = "https://%s%s".freeze

    def https_location(request)
      return sprintf(HTTPS_LOCATION, request.host, request.fullpath)
    end
  end
end
