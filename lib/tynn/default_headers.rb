class Tynn
  # Adds support to set default headers for responses.
  # This plugin is included by default.
  #
  # @example
  #   require "tynn"
  #   require "tynn/test"
  #
  #   Tynn.set(:default_headers, {
  #     "Content-Type" => "application/json"
  #   })
  #
  #   Tynn.define { }
  #
  #   app = Tynn::Test.new
  #   app.get("/")
  #
  #   app.res.headers
  #   # => { "Content-Type" => "application/json" }
  #
  module DefaultHeaders
    # @private
    def self.setup(app)
      app.settings[:default_headers] = {}
    end

    # @private
    module InstanceMethods
      def default_headers
        return Hash[settings[:default_headers]]
      end
    end
  end
end
