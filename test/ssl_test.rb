require_relative "helper"
require_relative "../lib/tynn/ssl"

class SSLTest < Tynn::TestCase
  class App < Tynn
  end

  setup do
    App.middleware.clear
  end

  test "redirects to https" do
    App.plugin(Tynn::SSL)
    App.define { }

    app = Tynn::Test.new(App)
    app.get("/")

    assert_equal 301, app.res.status
    assert_equal "https://example.org/", app.res.location
  end

  test "safe request" do
    App.plugin(Tynn::SSL)
    App.define { res.write("secure") }

    app = Tynn::Test.new(App)
    app.get("/", {}, "HTTPS" => "on")

    assert_equal 200, app.res.status
    assert_equal "secure", app.res.body
  end

  test "hsts header" do
    App.plugin(Tynn::SSL)
    App.define { }

    app = Tynn::Test.new(App)
    app.get("/", {}, "HTTPS" => "on")

    header = app.res.headers["Strict-Transport-Security"]
    result = "max-age=15552000; includeSubdomains"

    assert_equal result, header
  end

  test "hsts header with options" do
    App.plugin(Tynn::SSL, hsts: { expires: 1, subdomains: false, preload: true })
    App.define { }

    app = Tynn::Test.new(App)
    app.get("/", {}, "HTTPS" => "on")

    header = app.res.headers["Strict-Transport-Security"]
    result = "max-age=1; preload"

    assert_equal result, header
  end

  test "disable hsts" do
    App.plugin(Tynn::SSL, hsts: false)
    App.define { }

    app = Tynn::Test.new(App)
    app.get("/", {}, "HTTPS" => "on")

    header = app.res.headers["Strict-Transport-Security"]
    result = "max-age=0; includeSubdomains"

    assert_equal result, header
  end

  test "secure cookies" do
    App.plugin(Tynn::SSL, hsts: false)

    App.define do
      get do
        res.set_cookie("first", "cookie")
        res.set_cookie("other", value: "cookie", http_only: true)
      end
    end

    app = Tynn::Test.new(App)
    app.get("/", {}, "HTTPS" => "on")

    first, other = app.res.headers["Set-Cookie"].split("\n")

    assert_equal "first=cookie; secure", first
    assert_equal "other=cookie; HttpOnly; secure", other
  end
end
