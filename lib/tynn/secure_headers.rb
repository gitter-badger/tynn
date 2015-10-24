class Tynn
  # Public: Adds security related HTTP headers.
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/secure_headers"
  #
  #   Tynn.helpers(Tynn::SecureHeaders)
  #
  # This helper applies the following headers:
  #
  # *X-Content-Type-Options:* <tt>"nosniff"</tt>
  #
  # Prevents IE and Chrome from
  # {content type sniffing}[https://msdn.microsoft.com/library/gg622941(v=vs.85).aspx]
  #
  # *X-Frame-Options:* <tt>"SAMEORIGIN"</tt>
  #
  # Provides {Clickjacking}[https://www.owasp.org/index.php/Clickjacking]
  # protection.
  #
  # *X-Permitted-Cross-Domain-Policies:* <tt>"none"</tt>
  #
  # Restricts Adobe Flash Player's access to data.
  #
  # *X-XSS-Protection:* <tt>"1; mode=block"</tt>
  #
  # Enables the XSS protection filter built into IE, Chrome and Safari.
  # This filter is usually enabled by default, the use of this header
  # is to re-enable it if it was disabled by the user.
  #
  module SecureHeaders
    # Internal: Sets the default HTTP secure headers.
    def self.setup(app)
      app.settings[:default_headers].update(
        "X-Content-Type-Options" => "nosniff",
        "X-Frame-Options" => "SAMEORIGIN",
        "X-Permitted-Cross-Domain-Policies" => "none",
        "X-XSS-Protection" => "1; mode=block"
      )
    end
  end
end
