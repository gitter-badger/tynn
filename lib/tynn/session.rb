# Adds simple cookie based session management. If a secret token is
# given, it signs the cookie data to ensure that it cannot be altered
# by unauthorized means.
#
# ```
# require "tynn"
# require "tynn/session"
#
# Tynn.helpers(Tynn::Session, secret: "__change_me__")
#
# Tynn.define do
#   root do
#     res.write(sprintf("hei %s", session[:username]))
#   end
#
#   on(:username) do |username|
#     session[:username] = username
#   end
# end
# ```
#
# The following command generates a cryptographically secure secret ready
# to use:
#
# ```
# $ ruby -r securerandom -e "puts SecureRandom.hex(64)"
# ```
#
# It's important to keep the token secret. Knowing the token allows an
# attacker to tamper the data. So, it's recommended to load the token
# from the environment.
#
# ```
# Tynn.helpers(Tynn::Session, secret: ENV["SESSION_SECRET"])
# ```
#
# Under the hood, Tynn::Session uses the [Rack::Session::Cookie][rack-session]
# middleware. Thus, supports all the options available for this middleware.
#
# * `:key` - the name of the cookie. Defaults to `"rack.session"`.
# * `:expire_after` - sets the lifespan of the cookie. If `nil`,
#     the cookie will be deleted after the user close the browser.
#     Defaults to `nil`.
# * `:httponly` - if `true`, sets the [HttpOnly][cookie-httponly] attribute.
#   This mitigates the risk of client side scripting accessing the cookie.
#   Defaults to `true`.
# * `:secure` - if `true`, sets the [Secure][cookie-secure] attribute.
#   This tells the browser to only transmit the cookie over HTTPS. Defaults
#   to `false`.
#
# ```
# Tynn.helpers(
#   Tynn::Session,
#   key: "app",
#   secret: ENV["SESSION_SECRET"],
#   expire_after: 36_000, # seconds
#   httponly: true,
#   secure: true
# )
# ```
#
# [cookie-httponly]: https://www.owasp.org/index.php/Session_Management_Cheat_Sheet#HttpOnly_Attribute
# [cookie-secure]: https://www.owasp.org/index.php/Session_Management_Cheat_Sheet#Secure_Attribute
# [rack-session]: http://www.rubydoc.info/gems/rack/Rack/Session/Cookie
#
module Tynn::Session
  RACK_SESSION = "rack.session".freeze # :nodoc:

  def self.setup(app, options = {}) # :nodoc:
    app.use(Rack::Session::Cookie, options)
  end

  # Returns the session hash.
  #
  # ```
  # session # => {}
  #
  # session[:foo] = "foo"
  # session[:foo] # => "foo"
  # ```
  #
  def session
    return env[RACK_SESSION]
  end
end
