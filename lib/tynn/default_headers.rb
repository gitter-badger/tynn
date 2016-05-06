# frozen_string_literal: true

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
    def self.setup(app) # :nodoc:
      app.settings[:default_headers] = {}
    end

    module InstanceMethods # :nodoc:
      def default_headers
        Hash[settings[:default_headers]]
      end
    end
  end
end
