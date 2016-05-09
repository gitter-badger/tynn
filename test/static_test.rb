# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/tynn/static"

class StaticTest < Minitest::Test
  test "serves static files" do
    app = new_app

    app.plugin(Tynn::Static, %w(/test), root: Dir.pwd)

    app.define {}

    ts = Tynn::Test.new(app)
    ts.get("/test/static_test.rb")

    assert_equal File.read(__FILE__), ts.res.body
  end
end
