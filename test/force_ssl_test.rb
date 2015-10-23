require_relative "../lib/tynn/force_ssl"

setup do
  Tynn::Test.new
end

test "redirects to https" do |app|
  Tynn.helpers(Tynn::ForceSSL)

  Tynn.define do
  end

  app.get("/")

  assert_equal 301, app.res.status
  assert_equal "https://example.org/", app.res.location
end

test "https request" do |app|
  Tynn.helpers(Tynn::ForceSSL)

  Tynn.define do
    root do
      res.write("secure")
    end
  end

  app.get("/", {}, "HTTPS" => "on")

  assert_equal 200, app.res.status
  assert_equal "secure", app.res.body
end
