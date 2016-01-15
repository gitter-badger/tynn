require_relative "helper"
require_relative "../lib/tynn/protection"
require_relative "../lib/tynn/session"

class ProtectionTest < Tynn::TestCase
  class App < Tynn
    plugin(Tynn::Protection)
  end

  class SSLApp < Tynn
    plugin(Tynn::Protection, ssl: true, hsts: {
      expires: 1,
      subdomains: false,
      preload: true
    })
  end

  class SecureCookies < Tynn
    plugin(Tynn::SSL)
    plugin(Tynn::Session, key: "session", secret: "__an_insecure_secret_key__")

    define do
      get do
        session[:foo] = "foo"
      end
    end
  end

  test "secure headers" do
    assert_equal Tynn::SecureHeaders::HEADERS, App.settings[:default_headers]
  end

  test "ssl" do
    SSLApp.define {}

    app = Tynn::Test.new(SSLApp)
    app.get("/")

    assert_equal 301, app.res.status
    assert_equal "https://example.org/", app.res.location
  end

  test "hsts" do
    SSLApp.define {}

    app = Tynn::Test.new(SSLApp)
    app.get("/", {}, "HTTPS" => "on")

    header = app.res.headers["Strict-Transport-Security"]
    result = "max-age=1; preload"

    assert_equal result, header
  end

  test "secure cookies" do
    app = Tynn::Test.new(SecureCookies)
    app.get("/", {}, "HTTPS" => "on")

    regexp = /; secure/
    session = app.res.headers["Set-Cookie"]

    assert_match regexp, session
  end
end
