class Tynn
  # Public: Enforces secure HTTP requests by:
  #
  # 1. Redirecting HTTP requests to their HTTPS counterparts.
  #
  # 2. Setting the +Strict-Transport-Security+ header. This ensures the
  #    browser never visits the http version of a website. This reduces
  #    the impact of leaking session data through cookies and external
  #    links, and defends against Man-in-the-middle attacks.
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/ssl"
  #   require "tynn/test"
  #
  #   Tynn.plugin(Tynn::SSL)
  #
  #   Tynn.define { }
  #
  #   app = Tynn::Test.new
  #   app.get("/", {}, "HTTP_HOST" => "tynn.xyz")
  #
  #   app.res.headers["Location"]
  #   # => "https://tynn.xyz/"
  #
  # You can configure HSTS with <tt>{ hsts: { ... } }</tt>. It supports the
  # following options:
  #
  # expires    - The time, in seconds, that the browser access the site only
  #              by HTTPS. Defaults to 180 days.
  # subdomains - If this is +true+, the rule applies to all the site's
  #              subdomains as well. Defaults to +true+.
  # preload    - A limitation of HSTS is that the initial request remains
  #              unprotected if it uses HTTP. The same applies to the first
  #              request after the activity period specified by +max-age+.
  #              Modern browsers implements a "STS preloaded list", which
  #              contains known sites supporting HSTS. If you would like to
  #              include your website into the list, set this options to +true+
  #              and submit your domain to this {form}[https://hstspreload.appspot.com/].
  #              Supported by Chrome, Firefox, IE11+ and IE Edge.
  #
  # Examples
  #
  #   Tynn.plugin(
  #     Tynn::SSL,
  #     hsts: {
  #       expires: 31_536_000,
  #       includeSubdomains: true,
  #       preload: true
  #     }
  #   )
  #
  #   app = Tynn::Test.new
  #   app.get("/", {}, "HTTPS" => "on")
  #
  #   app.res.headers["Strict-Transport-Security"]
  #   # => "max-age=31536000; includeSubdomains; preload"
  #
  # To disable HSTS, you will need to tell the browser to expire it
  # immediately.
  #
  # Examples
  #
  #   Tynn.plugin(Tynn::SSL, hsts: { expires: 0 })
  #
  class SSL
    def self.setup(app, hsts: {}) # :nodoc:
      app.use(self, hsts: hsts)
    end

    def initialize(app, hsts: {}) # :nodoc:
      @app = app
      @hsts_header = build_hsts_header(hsts)
    end

    def call(env) # :nodoc:
      request = Rack::Request.new(env)

      if request.ssl?
        response = @app.call(env)

        set_hsts_header!(response[1])

        return response
      else
        return [301, redirect_headers(request), []]
      end
    end

    private

    def build_hsts_header(options)
      header = sprintf("max-age=%i", options.fetch(:expires, 15_552_000))
      header << "; includeSubdomains" if options.fetch(:subdomains, true)
      header << "; preload" if options[:preload]

      return header
    end

    def set_hsts_header!(headers)
      headers["Strict-Transport-Security".freeze] ||= @hsts_header
    end

    def redirect_headers(request)
      return { "Location" => https_location(request) }
    end

    HTTPS_LOCATION = "https://%s%s".freeze

    def https_location(request)
      return sprintf(HTTPS_LOCATION, request.host, request.fullpath)
    end
  end
end
