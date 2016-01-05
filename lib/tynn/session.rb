class Tynn
  # Public: Adds simple cookie based session management. You can pass a secret
  # token to sign the cookie data, thus unauthorized means can't alter it.
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/session"
  #
  #   Tynn.plugin(Tynn::Session, secret: "__change_me__")
  #
  #   Tynn.define do
  #     on("login") do
  #       post do
  #         # ...
  #
  #         session[:user_id] = user.id
  #
  #         res.redirect("/admin")
  #       end
  #     end
  #   end
  #
  # The following command generates a cryptographically secure secret ready
  # to use:
  #
  #   $ ruby -r securerandom -e "puts SecureRandom.hex(64)"
  #
  # It's important to keep the token secret. Knowing the token allows an
  # attacker to tamper the data. So, it's recommended to load the token
  # from the environment.
  #
  # Examples
  #
  #   Tynn.plugin(Tynn::Session, secret: ENV["SESSION_SECRET"])
  #
  # Under the hood, Tynn::Session uses the +Rack::Session::Cookie+ middleware.
  # Thus, supports all the options available for this middleware:
  #
  # key          - The name of the cookie. Defaults to <tt>"rack.session"</tt>.
  #
  # httponly     - If +true+, sets the +HttpOnly+ flag. This mitigates the
  #                risk of client side scripting accessing the cookie. Defaults
  #                to +true+.
  #
  # secure       - If +true+, sets the +Secure+ flag. This tells the browser
  #                to only transmit the cookie over HTTPS. Defaults to `false`.
  #
  # expire_after - The lifespan of the cookie. If +nil+, the session cookie
  #                is temporary and is no retained after the browser is
  #                closed. Defaults to +nil+.
  #
  # Examples
  #
  #   Tynn.plugin(
  #     Tynn::Session,
  #     key: "app",
  #     secret: ENV["SESSION_SECRET"],
  #     expire_after: 36_000, # seconds
  #     httponly: true,
  #     secure: true
  #   )
  #
  module Session
    # @private
    def self.setup(app, options = {})
      unless options[:secret]
        raise <<-MSG.gsub(/^[ \t]{10}/, "")
          No secret option provided.

          Tynn::Session uses a secret token to sign the cookie data, thus
          unauthorized means can't alter it. Please, add the secret option
          to your code:

              #{ app }.plugin(Tynn::Session, secret: "__a_long_random_secret__", ...)

          Make sure the secret is long and all random. You can generate a
          secure secret key with:

              $ ruby -r securerandom -e "puts SecureRandom.hex(64)"

          If you're sharing your code publicly, make sure the secret key
          is kept private. Knowing the secret allows an attacker to tamper
          the data. You can use environment variables to store the secret:

              #{ app }.plugin(Tynn::Session, secret: ENV.fetch("SESSION_SECRET"), ...)
        MSG
      end

      app.use(Rack::Session::Cookie, options)
    end

    module InstanceMethods
      # Public: Returns the session hash.
      #
      # Examples
      #
      #   session # => {}
      #
      #   session[:foo] = "foo"
      #   session[:foo] # => "foo"
      #
      def session
        return req.session
      end
    end
  end
end
