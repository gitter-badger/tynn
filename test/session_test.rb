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

  assert_equal "foo", app.res.body
  assert_equal "foo", app.req.env["rack.session"]["foo"]
  assert(/; HttpOnly$/ === app.res.headers["Set-Cookie"])
end
