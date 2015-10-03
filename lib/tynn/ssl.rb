module Tynn::SSL
  def self.setup(app, options = {}) # :nodoc:
    app.use(Tynn::SSL::Middleware, options)
  end

  class Middleware # :nodoc:
    HTTPS_LOCATION = "https://%s%s".freeze
    HSTS_HEADER = "Strict-Transport-Security".freeze
    HSTS_EXPIRE = 15_552_000 # 180 days

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
      result[1][HSTS_HEADER] = @hsts_header

      return result
    end

    private

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

    def https_location(request)
      return sprintf(HTTPS_LOCATION, request.host, request.fullpath)
    end
  end
end
