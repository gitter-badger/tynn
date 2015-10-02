require "json"

module Tynn::JSONParser
  def self.setup(app)
    app.use(Middleware)
  end

  class Middleware
    CONTENT_TYPE = "application/json".freeze
    FORM_HASH = "rack.request.form_hash".freeze
    FORM_INPUT = "rack.request.form_input".freeze

    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      if json?(request) && !(body = request.body.read).empty?
        request.body.rewind

        request.env[FORM_HASH] = JSON.parse(body)
        request.env[FORM_INPUT] = request.body
      end

      return @app.call(request.env)
    end

    def json?(request)
      return request.media_type == CONTENT_TYPE
    end
  end
end
