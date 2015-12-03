require "securerandom"
require_relative "../lib/tynn/session"

test "raise error if secret is not given" do
  assert_raise do
    Tynn.plugin(Tynn::Session)
  end
end

test "session" do
  Tynn.plugin(Tynn::Session, secret: SecureRandom.hex(64))

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
end
