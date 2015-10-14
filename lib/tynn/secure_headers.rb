class Tynn
  # Adds security related HTTP headers.
  #
  # ```
  # require "tynn"
  # require "tynn/secure_headers"
  #
  # Tynn.helpers(Tynn::SecureHeaders)
  # ```
  #
  # This helper applies the following headers:
  #
  # * **X-Content-Type-Options:** Prevents IE and Chrome from
  #   [content type sniffing][mime-sniffing].
  #
  # * **X-Frame-Options (XFO):** Provides [Clickjacking][clickjacking]
  #   protection. Check the [X-Frame-Options draft][x-frame-options] for
  #   more information.
  #
  # * **X-Permitted-Cross-Domain-Policies:** Restricts Adobe Flash Player's
  #   access to data. Check this [article][pcdp] for more information.
  #
  # * **X-XSS-Protection:** Enables the [XSS][xss] protection filter built
  #   into IE, Chrome and Safari. This filter is usually enabled by default,
  #   the use of this header is to re-enable it if it was disabled by the user.
  #
  # [clickjacking]: https://www.owasp.org/index.php/Clickjacking
  # [mime-sniffing]: https://msdn.microsoft.com/library/gg622941(v=vs.85).aspx
  # [pcdp]: https://www.adobe.com/devnet/adobe-media-server/articles/cross-domain-xml-for-streaming.html
  # [x-frame-options]: https://tools.ietf.org/html/draft-ietf-websec-x-frame-options-02
  # [xss]: https://www.owasp.org/index.php/Cross-site_Scripting_(XSS)
  #
  module SecureHeaders
    HEADERS = {
      "X-Content-Type-Options" => "nosniff",
      "X-Frame-Options" => "SAMEORIGIN",
      "X-Permitted-Cross-Domain-Policies" => "none",
      "X-XSS-Protection" => "1; mode=block"
    } # :nodoc:

    def default_headers # :nodoc:
      return super.merge(HEADERS)
    end
  end
end
