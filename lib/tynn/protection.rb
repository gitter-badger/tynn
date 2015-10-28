require_relative "secure_headers"

class Tynn
  # Public: Adds security measures against common attacks.
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/protection"
  #
  #   Tynn.plugin(Tynn::Protection)
  #
  # If you are using SSL/TLS (HTTPS), it's recommended to set
  # the +:ssl+ option:
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/protection"
  #
  #   Tynn.plugin(Tynn::Protection, ssl: true)
  #
  # By default, it includes the following security plugins:
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
    # Internal: Configures security related plugins.
    def self.setup(app, ssl: false, force_ssl: ssl, hsts: {})
      app.plugin(Tynn::SecureHeaders)

      if ssl
        app.settings[:ssl] = true

        require_relative "hsts"

        app.plugin(Tynn::HSTS, hsts)
      end

      if force_ssl
        require_relative "force_ssl"

        app.plugin(Tynn::ForceSSL)
      end
    end
  end
end
