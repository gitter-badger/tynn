# frozen_string_literal: true

require_relative "helper"

class DefaultHeadersTest < Minitest::Test
  test "sets default headers" do
    app = new_app

    app.default_headers = { "Content-Type" => "text/plain" }

    assert_equal "text/plain", app.default_headers["Content-Type"]
  end

  test "respond with default headers" do
    app = new_app

    app.default_headers = { "Content-Type" => "text/plain" }

    app.define {}

    ts = Tynn::Test.new(app)
    ts.get("/")

    assert_equal app.default_headers, ts.res.headers
  end
end
