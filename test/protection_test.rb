require_relative "helper"
require_relative "../lib/tynn/protection"

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

  test "secure headers" do
    assert_equal Tynn::SecureHeaders::HEADERS, App.settings[:default_headers]
  end

  test "ssl" do
    SSLApp.define { }

    app = Tynn::Test.new(SSLApp)
    app.get("/")

    assert_equal 301, app.res.status
    assert_equal "https://example.org/", app.res.location
  end

  test "hsts" do
    SSLApp.define { }

    app = Tynn::Test.new(SSLApp)
    app.get("/", {}, "HTTPS" => "on")

    header = app.res.headers["Strict-Transport-Security"]
    result = "max-age=1; preload"

    assert_equal result, header
  end
end
