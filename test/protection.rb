require "securerandom"
require_relative "../lib/tynn/protection"
require_relative "../lib/tynn/session"

test "includes secure headers" do
  Tynn.helpers(Tynn::Protection)

  assert Tynn.include?(Tynn::SecureHeaders)
end

test "sets httponly flag to cookies" do
  Tynn.helpers(Tynn::Protection)
  Tynn.helpers(Tynn::Session, secret: SecureRandom.hex(64))

  Tynn.define do
  end

  app = Tynn::Test.new
  app.get("/")

  assert_equal true, app.req.env["rack.session.options"][:http_only]
end

test "adds hsts header if ssl option is true" do
  Tynn.helpers(Tynn::Protection, ssl: true)

  Tynn.define do
  end

  app = Tynn::Test.new
  app.get("/", {}, "HTTPS" => "on")

  hsts = app.res.headers["Strict-Transport-Security"]

  assert_equal "max-age=15552000; includeSubdomains", hsts
end

test "supports hsts options" do
  hsts = { expires: 100, subdomains: false, preload: true }

  Tynn.helpers(Tynn::Protection, ssl: true, hsts: hsts)

  Tynn.define do
  end

  app = Tynn::Test.new
  app.get("/", {}, "HTTPS" => "on")

  hsts = app.res.headers["Strict-Transport-Security"]

  assert_equal "max-age=100; preload", hsts
end

test "adds secure flag to cookies if ssl option is true" do
  Tynn.helpers(Tynn::Protection, ssl: true)
  Tynn.helpers(Tynn::Session, secret: SecureRandom.hex(64))

  Tynn.define do
  end

  app = Tynn::Test.new
  app.get("/", {}, "HTTPS" => "on")

  session = app.req.env["rack.session.options"]

  assert_equal true, session[:http_only]
  assert_equal true, session[:secure]
end
