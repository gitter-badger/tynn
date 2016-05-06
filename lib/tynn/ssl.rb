# frozen_string_literal: true

class Tynn
  # Enforces secure HTTP requests by:
  #
  # 1. Redirecting HTTP requests to their HTTPS counterparts.
  #
  # 2. Setting the HTTP `Strict-Transport-Security` header (HSTS).
  #    This ensures the browser never visits the http version of a website.
  #    This reduces the impact of leaking session data through cookies
  #    and external links, and defends against Man-in-the-middle attacks.
  #
  # 3. Setting the `secure` flag on cookies. This tells the browser to only
  #    transmit them over HTTPS.
  #
  # You can configure HSTS passing a `:hsts` option. The following options
  # are supported:
  #
  # - **:expires** - The time, in seconds, that the browser access the site only
  #   by HTTPS. Defaults to 180 days.
  #
  # - **:subdomains** - If this is `true`, the rule applies to all the site's
  #   subdomains as well. Defaults to `false`.
  #
  # - **:preload** - A limitation of HSTS is that the initial request remains
  #   unprotected if it uses HTTP. The same applies to the first request after
  #   the activity period specified by `max-age`. Modern browsers implements a
  #   "STS preloaded list", which contains known sites supporting HSTS. If you
  #   would like to include your website into the list, set this options to
  #   `true` and submit your domain to this [form][hsts-preload]. Supported by
  #   Chrome, Firefox, IE11+ and IE Edge.
  #
  # [hsts-preload]: https://hstspreload.appspot.com/
  #
  # To disable HSTS, you will need to tell the browser to expire it immediately.
  # Setting `hsts: false` is a shortcut for `hsts: { expires: 0 }`.
  #
  # @example
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
  #   app.res.status   # => 301
  #   app.res.location # => "https://tynn.xyz/"
  #
  # @example Using different HSTS options
  #   Tynn.plugin(
  #     Tynn::SSL,
  #     hsts: {
  #       expires: 31_536_000,
  #       includeSubdomains: true,
  #       preload: true
  #     }
  #   )
  #
  # @example Disabling HSTS
  #   Tynn.plugin(Tynn::SSL, hsts: false)
  #
  module SSL
    def self.setup(app, hsts: {}) # :nodoc:
      middleware = proc do |_app_|
        Tynn::SSL::Middleware.new(_app_, hsts: hsts)
      end

      app.middleware.push(middleware)
    end

    class Middleware # :nodoc:
      HSTS_MAX_AGE = 15_552_000 # 180 days

      def initialize(app, hsts: {})
        @app = app
        @hsts_header = build_hsts_header(hsts || { expires: 0 })
      end

      def call(env)
        request = Rack::Request.new(env)

        return redirect_to_https(request) unless request.ssl?

        @app.call(env).tap do |_, headers, _|
          set_hsts_header!(headers)

          flag_cookies_as_secure!(headers)
        end
      end

      private

      def build_hsts_header(options)
        header = sprintf("max-age=%i", options.fetch(:expires, HSTS_MAX_AGE))
        header << "; includeSubdomains" if options[:subdomains]
        header << "; preload" if options[:preload]

        header
      end

      def redirect_to_https(request)
        [301, https_headers(request), []]
      end

      def https_headers(request)
        { "Location" => https_location(request) }
      end

      def https_location(request)
        host = request.host
        port = request.port

        location = "https://" + host
        location << ":#{ port }" if port != 80 && port != 443
        location << request.fullpath

        location
      end

      def set_hsts_header!(headers)
        headers["Strict-Transport-Security"] ||= @hsts_header
      end

      def flag_cookies_as_secure!(headers)
        return unless cookies = headers["Set-Cookie"]

        headers["Set-Cookie"] = cookies.split("\n").map do |cookie|
          cookie << "; secure" if cookie !~ /;\s*secure\s*(;|$)/i
          cookie
        end.join("\n")
      end
    end
  end
end
