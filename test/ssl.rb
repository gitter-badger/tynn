require_relative "../lib/tynn/ssl"

setup do
  Tynn::Test.new
end

test "redirects to https" do |app|
  Tynn.helpers(Tynn::SSL)

  Tynn.define do
  end

  app.get("/")

  assert_equal 301, app.res.status
  assert_equal "https://example.org/", app.res.location
end

test "https request" do |app|
  Tynn.helpers(Tynn::SSL)

  Tynn.define do
    root do
      res.write("secure")
    end
  end

  app.get("/", {}, "HTTPS" => "on")

  assert_equal "secure", app.res.body
end

test "hsts header" do |app|
  Tynn.helpers(Tynn::SSL)

  Tynn.define do
  end

  app = Tynn::Test.new
  app.get("/", {}, "HTTPS" => "on")

  header = app.res.headers["Strict-Transport-Security"]

  assert_equal "max-age=15552000; includeSubdomains", header
end

test "hsts header options" do |app|
  Tynn.helpers(Tynn::SSL, hsts: {
    expires: 1,
    subdomains: false,
    preload: true
  })

  Tynn.define do
  end

  app = Tynn::Test.new
  app.get("/", {}, "HTTPS" => "on")

  header = app.res.headers["Strict-Transport-Security"]

  assert_equal "max-age=1; preload", header
end
