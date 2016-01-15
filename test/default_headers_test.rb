require_relative "helper"

class DefaultHeadersTest < Tynn::TestCase
  class App < Tynn
    define {}
  end

  test "respond with default headers" do
    App.set(:default_headers, "Content-Type" => "text/plain")

    app = Tynn::Test.new(App)
    app.get("/")

    assert_equal "text/plain", app.res.content_type
  end
end
