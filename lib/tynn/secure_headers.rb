class Tynn
  # Adds the following security related HTTP headers:
  #
  # - **X-Content-Type-Options:** Prevents IE and Chrome from
  #   [content type sniffing][x-content-type]. Defaults to
  #   `"nosniff"`.
  #
  # - **X-Frame-Options:** Provides [Clickjacking][clickjacking]
  #   protection. Defaults to `"SAMEORIGIN"`.
  #
  # - **X-Permitted-Cross-Domain-Policies:** Restricts Adobe Flash
  #   Player's access to data. Defaults to `"none"`.
  #
  # - **X-XSS-Protection:** Enables the XSS protection filter built
  #   into IE, Chrome and Safari. This filter is usually enabled
  #   by default, the use of this header is to re-enable it if it
  #   was turned off by the user. Defaults to `"1; mode=block"`.
  #
  # @example
  #   require "tynn"
  #   require "tynn/secure_headers"
  #
  #   Tynn.plugin(Tynn::SecureHeaders)
  #
  # [clickjacking]: https://www.owasp.org/index.php/Clickjacking
  # [x-content-type]: https://msdn.microsoft.com/library/gg622941(v=vs.85).aspx
  #
  module SecureHeaders
    # @private
    HEADERS = {
      "X-Content-Type-Options" => "nosniff",
      "X-Frame-Options" => "SAMEORIGIN",
      "X-Permitted-Cross-Domain-Policies" => "none",
      "X-XSS-Protection" => "1; mode=block"
    }

    # @private
    def self.setup(app)
      app.settings[:default_headers].update(HEADERS)
    end
  end
end
