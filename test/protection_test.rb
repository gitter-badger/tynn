require_relative "../lib/tynn/protection"

test "includes secure headers" do
  Tynn.helpers(Tynn::Protection)

  assert Tynn.include?(Tynn::SecureHeaders)
end

test "includes ssl helper if ssl is true" do
  Tynn.helpers(Tynn::Protection, ssl: true)

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
