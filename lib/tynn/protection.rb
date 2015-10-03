require_relative "hsts"
require_relative "secure_headers"

module Tynn::Protection
  def self.setup(app, options = {}) # :nodoc:
    app.settings[:protection] ||= {}

    app.helpers(Tynn::SecureHeaders)

    if options[:ssl]
      app.settings[:protection][:ssl] = true

      app.helpers(Tynn::HSTS, options.fetch(:hsts, {}))
    end
  end
end
