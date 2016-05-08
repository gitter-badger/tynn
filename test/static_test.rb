# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/tynn/static"

class StaticTest < Tynn::TestCase
  setup do
    @app_class = Class.new(Tynn)
  end

  test "serves static files" do
    @app_class.plugin(Tynn::Static, %w(/test), root: Dir.pwd)
    @app_class.define {}

    app = Tynn::Test.new(@app_class)
    app.get("/test/static_test.rb")

    assert_equal File.read(__FILE__), app.res.body
  end
end
