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

test "secure cookies" do |app|
  Tynn.helpers(Tynn::SSL)

  Tynn.define do
    get do
      res.set_cookie("first", "cookie")
      res.set_cookie("other", "cookie")
    end
  end

  app = Tynn::Test.new
  app.get("/", {}, "HTTPS" => "on")

  first, other = app.res.headers["Set-Cookie"].split("\n")

  assert_equal "first=cookie; secure", first
  assert_equal "other=cookie; secure", other
end
