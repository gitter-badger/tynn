require "json"

class Tynn
  # Adds helper methods for JSON generation.
  #
  # @example
  #   require "tynn"
  #   require "tynn/json"
  #
  #   Tynn.plugin(Tynn::JSON)
  #
  module JSON
    module InstanceMethods
      # Calls `to_json` on `data` and writes the generated JSON
      # object into the response body. Also, It automatically sets the
      # `Content-Type` header to `application/json`.
      #
      # @param data Any object that responds to `to_json`.
      #
      # @example
      #   Tynn.define do
      #     on("hash") do
      #       json(foo: "bar")
      #     end
      #
      #     on("array") do
      #       json([1, 2, 3])
      #     end
      #
      #     on("to_json") do
      #       json(Model.first)
      #     end
      #   end
      #
      # @return [void]
      #
      def json(data)
        res.headers[Rack::CONTENT_TYPE] = "application/json".freeze
        res.write(data.to_json)
      end
    end
  end
end
