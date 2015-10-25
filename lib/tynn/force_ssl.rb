class Tynn
  # Public: HTTP requests are permanently redirected to their HTTPS
  # counterparts.
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/force_ssl"
  #   require "tynn/test"
  #
  #   Tynn.helpers(Tynn::ForceSSL)
  #
  #   Tynn.define { }
  #
  #   app = Tynn::Test.new
  #   app.get("/", {}, "HTTP_HOST" => "tynn.ru")
  #
  #   app.res.headers["Location"]
  #   # => "https://tynn.ru/"
  #
  module ForceSSL
    # Internal: Sets the HTTPS redirect middleware.
    def self.setup(app)
      app.use(Tynn::ForceSSL::Middleware)
    end

    class Middleware
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
end
