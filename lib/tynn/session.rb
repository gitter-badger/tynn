# Adds a simple cookie based session management.
#
#     require "tynn"
#     require "tynn/session"
#
#     Tynn.helpers(Tynn::Session, secret: ENV["SESSION_SECRET"])
#
#     Tynn.define do
#       get do
#         user = User[session[:user_id]]
#         # ...
#       end
#
#       post do
#         # ...
#         session[:user_id] = user.id
#         # ...
#       end
#     end
#
# Under the hood, it uses the [Rack::Session::Cookie][rack-session] middleware.
# Thus, supports all the options available for this middleware.
#
#     Tynn.helpers(
#       Tynn::Session,
#       key: ENV["SESSION_KEY"],
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
