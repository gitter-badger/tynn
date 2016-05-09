# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/tynn/session"
require_relative "../lib/tynn/ssl"

class SSLTest < Minitest::Test
  setup do
    @app = new_app
  end

  test "redirects to https" do
    @app.plugin(Tynn::SSL)
    @app.define {}

    ts = Tynn::Test.new(@app)
    ts.get("/")

    assert_equal 301, ts.res.status
    assert_equal "https://example.org/", ts.res.location
  end

  test "redirects to non-default port" do
    @app.plugin(Tynn::SSL)
    @app.define {}

    ts = Tynn::Test.new(@app)
    ts.get("/", {}, "HTTP_HOST" => "example.org:4567")

    assert_equal 301, ts.res.status
    assert_equal "https://example.org:4567/", ts.res.location
  end

  test "safe request" do
    @app.plugin(Tynn::SSL)
    @app.define { res.write("secure") }

    ts = Tynn::Test.new(@app)
    ts.get("/", {}, "HTTPS" => "on")

    assert_equal 200, ts.res.status
    assert_equal "secure", ts.res.body
  end

  test "hsts header" do
    @app.plugin(Tynn::SSL)
    @app.define {}

    ts = Tynn::Test.new(@app)
    ts.get("/", {}, "HTTPS" => "on")

    header = ts.res.headers["Strict-Transport-Security"]
    result = "max-age=15552000"

    assert_equal result, header
  end

  test "hsts header with options" do
    @app.plugin(Tynn::SSL, hsts: {
      expires: 1, subdomains: true, preload: true
    })

    @app.define {}

    ts = Tynn::Test.new(@app)
    ts.get("/", {}, "HTTPS" => "on")

    header = ts.res.headers["Strict-Transport-Security"]
    result = "max-age=1; includeSubdomains; preload"

    assert_equal result, header
  end

  test "disable hsts" do
    @app.plugin(Tynn::SSL, hsts: false)
    @app.define {}

    ts = Tynn::Test.new(@app)
    ts.get("/", {}, "HTTPS" => "on")

    header = ts.res.headers["Strict-Transport-Security"]
    result = "max-age=0"

    assert_equal result, header
  end

  test "secure cookies" do
    @app.plugin(Tynn::SSL, hsts: false)

    @app.define do
      get do
        res.set_cookie("first", "cookie")
        res.set_cookie("other", value: "cookie", http_only: true)
        res.set_cookie("secure", value: "cookie", secure: true)
      end
    end

    ts = Tynn::Test.new(@app)
    ts.get("/", {}, "HTTPS" => "on")

    first, other, secure = ts.res.headers["Set-Cookie"].split("\n")

    assert_equal "first=cookie; secure", first
    assert_equal "other=cookie; HttpOnly; secure", other
    assert_equal "secure=cookie; secure", secure
  end

  test "middleware always execute before others" do
    @app.plugin(Tynn::Session, key: "session", secret: "secret")
    @app.plugin(Tynn::SSL)

    @app.define do
      get do
        session[:foo] = "foo"
      end
    end

    ts = Tynn::Test.new(@app)
    ts.get("/", {}, "HTTPS" => "on")

    assert_match(/; secure/, ts.res.headers["Set-Cookie"])
  end
end
