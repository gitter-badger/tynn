require_relative "../lib/tynn/protection"
require_relative "../lib/tynn/session"

test "includes secure headers" do
  Tynn.helpers(Tynn::Protection)

  assert Tynn.include?(Tynn::SecureHeaders)
end

test "includes ssl helpers if ssl is true" do
  Tynn.helpers(Tynn::Protection, ssl: true)

  assert Tynn.include?(Tynn::HSTS)
  assert Tynn.include?(Tynn::SSL)
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

test "adds secure flag to session cookie" do
  Tynn.helpers(Tynn::Protection, ssl: true)
  Tynn.helpers(Tynn::Session, secret: "_this_must_be_random_")

  Tynn.define do
    root do
      session[:foo] = "foo"
    end
  end

  app = Tynn::Test.new
  app.get("/", {}, "HTTPS" => "on")

  session, _ = app.res.headers["Set-Cookie"].split("\n")

  assert(/;\s*secure\s*(;|$)/i === session)
end

test "if session uses secure flag" do
  Tynn.helpers(Tynn::Protection, ssl: true)
  Tynn.helpers(Tynn::Session, secret: "_this_must_be_random_", secure: true)

  Tynn.define do
    root do
      session[:foo] = "foo"
    end
  end

  app = Tynn::Test.new
  app.get("/", {}, "HTTPS" => "on")

  session, _ = app.res.headers["Set-Cookie"].split("\n")

  assert(/;\s*secure\s*(;|$)/i === session)
end
