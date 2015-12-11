class Tynn
  module DefaultHeaders
    def self.setup(app)
      app.settings[:default_headers] = {}
    end

    module InstanceMethods
      def default_headers
        return Hash[settings[:default_headers]]
      end
    end
  end
end
