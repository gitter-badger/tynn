require "securerandom"
require_relative "../lib/tynn/session"

test "session" do
  Tynn.helpers(Tynn::Session, secret: SecureRandom.hex(64))

  Tynn.define do
    root do
      session[:foo] = "foo"

      res.write(session[:foo])
    end
  end

  app = Tynn::Test.new
  app.get("/")

  env = app.req.env
  session = env["rack.session"]
  session_options = env["rack.session.options"]

  assert_equal "foo", app.res.body
  assert_equal "foo", session["foo"]
  assert_equal true, session_options[:http_only]
end
