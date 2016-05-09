# frozen_string_literal: true

require "syro"
require_relative "request"
require_relative "response"

class Tynn
  module Base
    def self.setup(app) # :nodoc:
      app.include(Syro::Deck::API)
    end

    module ClassMethods
      # Sets the application handler.
      #
      #   class Users < Tynn
      #   end
      #
      #   Users.define do
      #     on(:id) do
      #       id = inbox[:id]
      #
      #       get do
      #         res.write("GET /users/#{ id }")
      #       end
      #
      #       post do
      #         res.write("POST /users/#{ id }")
      #       end
      #     end
      #   end
      #
      def define(&block)
        self.app = Syro.new(self, &block)
      end

      def call(env) # :nodoc:
        app.call(env)
      end

      def app # :nodoc:
        (defined?(@__app) && @__app) or raise(HandlerNotFound, self)
      end

      def app=(app) # :nodoc:
        @__app = app
      end
    end

    module InstanceMethods # :nodoc:
      def request_class
        Tynn::Request
      end

      def response_class
        Tynn::Response
      end
    end
  end
end
