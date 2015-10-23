class Tynn
  # Sets the `Strict-Transport-Security` HTTP header. This header
  # ensures the browser never visits the http version of a website.
  # This reduces the impact of leaking session data through cookies
  # and external links, and defends against Man-in-the-middle attacks.
  #
  # ```
  # require "tynn"
  # require "tynn/hsts"
  #
  # Tynn.helpers(Tynn::HSTS)
  #
  # Tynn.define { }
  #
  # Tynn.call("PATH_INFO" => "/")[1]["Strict-Transport-Security"]
  # # => "max-age=15552000; includeSubdomains"
  # ```
  #
  # It supports the following options:
  #
  # * `:expires`: The time, in seconds, that the browser access the site only
  #   by HTTPS. Defaults to 180 days.
  #
  # * `:includeSubdomains`: If this is `true`, the rule applies to all the
  #   site's subdomains as well. Defaults to `true`.
  #
  # * `:preload`: A limitation of HSTS is that the initial request remains
  #   unprotected if it uses HTTP. The same applies to the first request
  #   after the activity period specified by `max-age`. Modern browsers
  #   implements a "STS preloaded list", which contains known sites supporting
  #   HSTS. If you would like to include your website into the list, set this
  #   options to `true` and submit your domain to this [form][hsts-form].
  #   Supported by Chrome, Firefox and IE11+.
  #
  # ```
  # Tynn.helpers(
  #   Tynn::HSTS,
  #   expires: 31_536_000,
  #   includeSubdomains: true,
  #   preload: true
  # )
  #
  # Tynn.define { }
  #
  # Tynn.call("PATH_INFO" => "/")[1]["Strict-Transport-Security"]
  # # => "max-age=31536000; includeSubdomains; preload"
  # ```
  #
  # [hsts-form]: https://hstspreload.appspot.com/
  #
  module HSTS
    def self.setup(app, options = {}) # :nodoc:
      header = sprintf("max-age=%i", options.fetch(:expires, 15_552_000))
      header << "; includeSubdomains" if options.fetch(:subdomains, true)
      header << "; preload" if options[:preload]

      app.settings[:default_headers]["Strict-Transport-Security"] = header
    end
  end
end
