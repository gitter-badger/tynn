# frozen_string_literal: true

class Tynn
  # Adds support to set default headers for responses.
  #
  #   require "tynn"
  #   require "tynn/test"
  #
  #   Tynn.default_headers = {
  #     "Content-Type" => "application/json"
  #   }
  #
  #   Tynn.define { }
  #
  #   app = Tynn::Test.new
  #   app.get("/")
  #
  #   app.res.headers
  #   # => { "Content-Type" => "application/json" }
  #
  # This plugin is included by default.
  #
  module DefaultHeaders
    def self.setup(app) # :nodoc:
      app.default_headers = {}
    end

    module ClassMethods
      # Sets the default headers for the application.
      #
      #   Tynn.default_headers = {
      #     "Content-Type" => "application/json"
      #   }
      #
      #   Tynn.default_headers["Content-Type"]
      #   # => "application/json"
      #
      def default_headers=(headers)
        set(:default_headers, headers)
      end

      # Returns a Hash with the default headers.
      #
      #   Tynn.default_headers = {
      #     "Content-Type" => "application/json"
      #   }
      #
      #   Tynn.default_headers["Content-Type"]
      #   # => "application/json"
      #
      def default_headers
        settings[:default_headers]
      end
    end

    module InstanceMethods # :nodoc:
      def default_headers
        Hash[self.class.default_headers]
      end
    end
  end
end
