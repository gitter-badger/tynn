class Tynn
  module SSL
    def self.setup(app) # :nodoc:
      app.use(Tynn::SSL::Middleware)
    end

    class Middleware # :nodoc:
      def initialize(app)
        @app = app
      end

      def call(env)
        request = Rack::Request.new(env)

        unless request.ssl?
          return [301, redirect_headers(request), []]
        end

        result = @app.call(env)

        set_cookies_as_secure(result[1])

        return result
      end

      private

      def redirect_headers(request)
        return {
          "Content-Type" => "text/html",
          "Location" => https_location(request)
        }
      end

      HTTPS_LOCATION = "https://%s%s".freeze

      def https_location(request)
        return sprintf(HTTPS_LOCATION, request.host, request.fullpath)
      end

      COOKIE_HEADER = "Set-Cookie".freeze
      COOKIE_SEPARATOR = "\n".freeze
      COOKIE_REGEXP = /;\s*secure\s*(;|$)/i

      def set_cookies_as_secure(headers)
        return unless cookies = headers[COOKIE_HEADER]

        cookies = cookies.split(COOKIE_SEPARATOR).map do |cookie|
          (cookie !~ COOKIE_REGEXP) ?  "#{ cookie }; secure" : cookie
        end

        headers[COOKIE_HEADER] = cookies.join(COOKIE_SEPARATOR)
      end
    end
  end
end
