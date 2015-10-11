# Adds simple cookie based session management. If a secret token is
# given, it signs the cookie data to ensure that it cannot be altered
# by unauthorized means.
#
#
#     require "tynn"
#     require "tynn/session"
#
#     Tynn.helpers(Tynn::Session, secret: "__change_me__")
#
# The following command generates a cryptographically secure secret ready
# to use:
#
#     $ ruby -r securerandom -e "puts SecureRandom.hex(64)"
#
# It's important to keep the token secret. Knowing the token allows an
# attacker to tamper the data. So, it's recommended to load the token
# from the environment.
#
#     Tynn.helpers(Tynn::Session, secret: ENV["SESSION_SECRET"])
#
# Under the hood, Tynn::Session uses the [Rack::Session::Cookie][rack-session]
# middleware. Thus, supports all the options available for this middleware.
#
#     Tynn.helpers(
#       Tynn::Session,
#       key: "app",
#       secret: ENV["SESSION_SECRET"],
#       expire_after: nil,
#       httponly: true,
#       secure: true
#     )
#
# [rack-session]: http://www.rubydoc.info/gems/rack/Rack/Session/Cookie
#
module Tynn::Session
  RACK_SESSION = "rack.session".freeze # :nodoc:

  def self.setup(app, options = {}) # :nodoc:
    options = options.dup
    options[:httponly] ||= true

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
