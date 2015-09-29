class Tynn
  module Session
    RACK_SESSION = "rack.session".freeze

    def self.setup(app, options = {})
      app.use(Rack::Session::Cookie, options)
    end

    def session
      return env[RACK_SESSION]
    end
  end
end
