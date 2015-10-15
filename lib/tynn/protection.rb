require_relative "secure_headers"

class Tynn
  # Adds security measures against common attacks.
  #
  # ```
  # require "tynn"
  # require "tynn/protection"
  #
  # Tynn.helpers(Tynn::Protection)
  # ```
  #
  # If you are using SSL/TLS (HTTPS), it's recommended to set
  # the `:ssl` option:
  #
  # ```
  # require "tynn"
  # require "tynn/protection"
  #
  # Tynn.helpers(Tynn::Protection, ssl: true)
  # ```
  #
  # By default, it includes the following security helpers:
  #
  # * Tynn::SecureHeaders
  #
  # If the `:ssl` option is `true`, includes:
  #
  # * Tynn::SSL
  #
  module Protection
    def self.setup(app, ssl: false, hsts: {}) # :nodoc:
      app.helpers(Tynn::SecureHeaders)

      if ssl
        require_relative "ssl"

        app.helpers(Tynn::SSL, hsts: hsts)
      end
    end
  end
end
