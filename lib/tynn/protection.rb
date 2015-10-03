require_relative "secure_headers"

module Tynn::Protection
  def self.setup(app, ssl: false, hsts: {}) # :nodoc:
    app.helpers(Tynn::SecureHeaders)

    if ssl
      require_relative "ssl"

      app.helpers(Tynn::SSL, hsts: hsts)
    end
  end
end
