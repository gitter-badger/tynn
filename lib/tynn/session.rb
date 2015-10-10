module Tynn::Session
  RACK_SESSION = "rack.session".freeze # :nodoc:

  def self.setup(app, options = {}) # :nodoc:
    options = options.dup
    options[:http_only] ||= true

    app.use(Rack::Session::Cookie, options)
  end

  # Returns the session hash.
  #
  #     session # => {}
  #
  #     session[:foo] = "foo"
  #     session[:foo] # => "foo"
  #
  def session
    return env[RACK_SESSION]
  end
end
