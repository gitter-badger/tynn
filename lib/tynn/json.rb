require "json"

class Tynn
  # Public: Adds helper methods for json generation.
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/json"
  #
  #   Tynn.helpers(Tynn::JSON)
  #
  module JSON
    CONTENT_TYPE = "application/json".freeze

    module InstanceMethods
      # Public: Calls +to_json+ on +data+ and writes the generated \JSON
      # object into the response body. Also, It automatically sets the
      # +Content-Type+ header to +application/json+.
      #
      # data - Any object that responds to +to_json+.
      #
      # Examples
      #
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
      def json(data)
        res.headers[Rack::CONTENT_TYPE] = Tynn::JSON::CONTENT_TYPE

        res.write(data.to_json)
      end
    end
  end
end
