# frozen_string_literal: true

class Tynn
  module StatusHandler
    # @private
    def self.setup(app, handlers = {})
      app.set(:status_handlers, handlers)
    end

    module ClassMethods
      def handlers
        settings[:status_handlers]
      end

      def handle(status, method)
        handlers[status] = method
      end
    end

    # @private
    module InstanceMethods
      def call(*)
        response = super
        status, _, body = response

        handler = self.class.handlers[status]

        return response unless handler && body.empty?

        public_send(handler)

        res.finish
      end
    end
  end
end
