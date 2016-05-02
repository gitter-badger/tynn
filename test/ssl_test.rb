# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/tynn/ssl"

class SSLTest < Tynn::TestCase
  class App < Tynn
  end

  setup do
    App.reset!
  end

  test "redirects to https" do
    App.plugin(Tynn::SSL)
    App.define {}

    app = Tynn::Test.new(App)
    app.get("/")

    assert_equal 301, app.res.status
    assert_equal "https://example.org/", app.res.location
  end

  test "redirects to non-default port" do
    App.plugin(Tynn::SSL)
    App.define {}

    app = Tynn::Test.new(App)
    app.get("/", {}, "HTTP_HOST" => "example.org:4567")

    assert_equal 301, app.res.status
    assert_equal "https://example.org:4567/", app.res.location
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
    App.define {}

    app = Tynn::Test.new(App)
    app.get("/", {}, "HTTPS" => "on")

    header = app.res.headers["Strict-Transport-Security"]
    result = "max-age=15552000"

    assert_equal result, header
  end

  test "hsts header with options" do
    App.plugin(Tynn::SSL, hsts: {
      expires: 1, subdomains: true, preload: true
    })

    App.define {}

    app = Tynn::Test.new(App)
    app.get("/", {}, "HTTPS" => "on")

    header = app.res.headers["Strict-Transport-Security"]
    result = "max-age=1; includeSubdomains; preload"

    assert_equal result, header
  end

  test "disable hsts" do
    App.plugin(Tynn::SSL, hsts: false)
    App.define {}

    app = Tynn::Test.new(App)
    app.get("/", {}, "HTTPS" => "on")

    header = app.res.headers["Strict-Transport-Security"]
    result = "max-age=0"

    assert_equal result, header
  end

  test "secure cookies" do
    App.plugin(Tynn::SSL, hsts: false)

    App.define do
      get do
        res.set_cookie("first", "cookie")
        res.set_cookie("other", value: "cookie", http_only: true)
        res.set_cookie("secure", value: "cookie", secure: true)
      end
    end

    app = Tynn::Test.new(App)
    app.get("/", {}, "HTTPS" => "on")

    first, other, secure = app.res.headers["Set-Cookie"].split("\n")

    assert_equal "first=cookie; secure", first
    assert_equal "other=cookie; HttpOnly; secure", other
    assert_equal "secure=cookie; secure", secure
  end

  test "middleware always execute before others" do
    App.plugin(Tynn::Session, key: "session", secret: "secret")
    App.plugin(Tynn::SSL)

    App.define do
      get do
        session[:foo] = "foo"
      end
    end

    app = Tynn::Test.new(App)
    app.get("/", {}, "HTTPS" => "on")

    assert_match(/; secure/, app.res.headers["Set-Cookie"])
  end
end
