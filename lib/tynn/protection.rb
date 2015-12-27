require_relative "secure_headers"

class Tynn
  # Adds security measures against common attacks. If you are using
  # SSL/TLS (HTTPS), it's recommended to set the `:ssl` option.
  #
  # This plugin is composed by the following security plugins:
  #
  # - {Tynn::SecureHeaders}
  # - {Tynn::SSL}, if `:ssl` is `true`.
  #
  # @example
  #   require "tynn"
  #   require "tynn/protection"
  #
  #   Tynn.plugin(Tynn::Protection, ssl: true)
  #
  module Protection
    # @private
    def self.setup(app, ssl: false, hsts: {})
      app.plugin(Tynn::SecureHeaders)

      if ssl
        app.settings[:ssl] = true

        require_relative "ssl"

        app.plugin(Tynn::SSL, hsts: hsts)
      end
    end
  end
end
