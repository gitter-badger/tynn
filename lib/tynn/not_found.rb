# frozen_string_literal: true

require_relative "status_handler"

class Tynn
  module NotFound
    # @private
    def self.setup(app)
      app.plugin(Tynn::StatusHandler)
      app.handle(404, :not_found)
    end

    # @private
    module InstanceMethods
      def not_found
      end
    end
  end
end
