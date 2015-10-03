require_relative "secure_headers"

module Tynn::Protection
  def self.setup(app, ssl: false, **options) # :nodoc:
    app.settings[:protection] ||= {}

    app.helpers(Tynn::SecureHeaders)

    if ssl
      require_relative "ssl"

      app.settings[:protection][:ssl] = true

      app.helpers(Tynn::SSL, options)
    end
  end
end
