# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/tynn/protection"
require_relative "../lib/tynn/session"

class ProtectionTest < Minitest::Test
  SECURE_HEADERS = Tynn::SecureHeaders::HEADERS

  SSL_OPTIONS = {
    ssl: true,
    hsts: {
      expires: 1,
      subdomains: false,
      preload: true
    }
  }

  test "adds secure headers" do
    app = new_app

    app.plugin(Tynn::Protection)

    assert_equal SECURE_HEADERS, app.default_headers
  end

  test "adds ssl redirect" do
    app = new_app

    app.plugin(Tynn::Protection, SSL_OPTIONS)

    app.define {}

    ts = Tynn::Test.new(app)
    ts.get("/")

    assert_equal 301, ts.res.status
    assert_equal "https://example.org/", ts.res.location
  end

  test "adds hsts header" do
    app = new_app

    app.plugin(Tynn::Protection, SSL_OPTIONS)

    app.define {}

    ts = Tynn::Test.new(app)
    ts.get("/", {}, "HTTPS" => "on")

    header = ts.res.headers["Strict-Transport-Security"]
    result = "max-age=1; preload"

    assert_equal result, header
  end

  test "secure cookies" do
    app = new_app

    app.plugin(Tynn::SSL)

    app.plugin(Tynn::Session, key: "session", secret: "__an_insecure_secret_key__")

    app.define do
      get do
        session[:foo] = "foo"
      end
    end

    ts = Tynn::Test.new(app)
    ts.get("/", {}, "HTTPS" => "on")

    regexp = /; secure/
    session = ts.res.headers["Set-Cookie"]

    assert_match regexp, session
  end
end
