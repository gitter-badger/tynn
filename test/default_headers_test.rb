# frozen_string_literal: true

require_relative "helper"

class DefaultHeadersTest < Tynn::TestCase
  setup do
    @app_class = Class.new(Tynn)
    @app_class.define {}
  end

  test "respond with default headers" do
    @app_class.default_headers = { "Content-Type" => "text/plain" }

    app = Tynn::Test.new(@app_class)
    app.get("/")

    assert_equal @app_class.default_headers, app.res.headers
  end
end
