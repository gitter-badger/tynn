class Tynn
  module SSL
    def self.setup(app, hsts: {}) # :nodoc:
      app.use(Tynn::SSL::Middleware, hsts: hsts)
    end

    class Middleware # :nodoc:
      def initialize(app, hsts: {})
        @app = app
        @hsts_header = build_hsts_header(hsts)
      end

      def call(env)
        request = Rack::Request.new(env)

        unless request.ssl?
          return [301, redirect_headers(request), []]
        end

        result = @app.call(env)

        set_hsts_header(result[1])
        set_cookies_as_secure(result[1])

        return result
      end

      private

      HSTS_HEADER = "Strict-Transport-Security".freeze
      HSTS_EXPIRE = 15_552_000 # 180 days

      def build_hsts_header(options)
        header = sprintf("max-age=%i", options.fetch(:expires, HSTS_EXPIRE))
        header << "; includeSubdomains" if options.fetch(:subdomains, true)
        header << "; preload" if options[:preload]

        return header
      end

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

      def set_hsts_header(headers)
        headers[HSTS_HEADER] = @hsts_header
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
