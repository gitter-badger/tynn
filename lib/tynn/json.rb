require "json"

class Tynn
  module JSON
    JSON_CONTENT_TYPE = "application/json".freeze # :nodoc:

    def json(data)
      res.headers[Rack::CONTENT_TYPE] = JSON_CONTENT_TYPE

      res.write(data.to_json)
    end
  end
end
