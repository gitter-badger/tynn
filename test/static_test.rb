# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/tynn/static"

class StaticTest < Tynn::TestCase
  test "serves static files" do
    Tynn.plugin(Tynn::Static, %w(/test), root: Dir.pwd)

    Tynn.define {}

    app = Tynn::Test.new
    app.get("/test/static_test.rb")

    assert_equal File.read(__FILE__), app.res.body
  end
end
