module Tynn::Session
  RACK_SESSION = "rack.session".freeze # :nodoc:

  def self.setup(app, options = {}) # :nodoc:
    app.use(Rack::Session::Cookie, options)
  end

  def session
    return env[RACK_SESSION]
  end
end
