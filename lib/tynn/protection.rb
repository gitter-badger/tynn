require_relative "secure_headers"

class Tynn
  # Public: Adds security measures against common attacks.
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/protection"
  #
  #   Tynn.helpers(Tynn::Protection)
  #
  # If you are using SSL/TLS (HTTPS), it's recommended to set
  # the +:ssl+ option:
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/protection"
  #
  #   Tynn.helpers(Tynn::Protection, ssl: true)
  #
  # By default, it includes the following security helpers:
  #
  # - Tynn::SecureHeaders
  #
  # If the +:ssl+ option is +true+, includes:
  #
  # - Tynn::HSTS
  #
  # - Tynn::ForceSSL
  #
  module Protection
    # Internal: Configures security related extensions.
    def self.setup(app, ssl: false, force_ssl: ssl, hsts: {})
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
