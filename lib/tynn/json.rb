require "json"

class Tynn
  # Adds helper methods for json generation.
  #
  # ```
  # require "tynn"
  # require "tynn/json"
  #
  # Tynn.helpers(Tynn::JSON)
  # ```
  #
  module JSON
    JSON_CONTENT_TYPE = "application/json".freeze # :nodoc:

    # Calls `to_json` on `data` and writes the generated \JSON object into
    # the response body. Also, It automatically sets the `Content-Type`
    # header to `application/json`.
    #
    # ```
    # Tynn.define do
    #   on("hash") do
    #     json(foo: "bar")
    #   end
    #
    #   on("array") do
    #     json([1, 2, 3])
    #   end
    #
    #   on("to_json") do
    #     json(Model.first)
    #   end
    # end
    # ```
    #
    def json(data)
      res.headers[Rack::CONTENT_TYPE] = JSON_CONTENT_TYPE

      res.write(data.to_json)
    end
  end
end
