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
end
