# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/tynn/static"

class StaticTest < Tynn::TestCase
  class App < Tynn
    plugin Tynn::Static, %w(/test), root: Dir.pwd

    define {}
  end

  test "serves static files" do
    app = Tynn::Test.new(App)
    app.get("/test/static_test.rb")

    assert_equal File.read(__FILE__), app.res.body
  end
end
