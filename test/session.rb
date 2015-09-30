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

  env = app.last_request.env

  assert_equal "foo", app.res.body
  assert_equal "foo", env["rack.session"]["foo"]
end
