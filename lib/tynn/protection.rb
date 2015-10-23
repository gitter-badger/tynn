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
  # * Tynn::HSTS
  # * Tynn::ForceSSL
  #
  # You can disable TLS redirect by:
  #
  # ```
  # Tynn.helpers(Tynn::Protection, ssl: true, force_ssl: false)
  # ```
  #
  module Protection
    def self.setup(app, ssl: false, force_ssl: ssl, hsts: {}) # :nodoc:
      app.helpers(Tynn::SecureHeaders)

      if ssl
        app.settings[:ssl] = true

        require_relative "hsts"

        app.helpers(Tynn::HSTS, hsts)
      end

      if force_ssl
        require_relative "force_ssl"

        app.helpers(Tynn::ForceSSL)
      end
    end
  end
end
