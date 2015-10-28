require_relative "../lib/tynn/static"

test "static" do
  Tynn.plugin(Tynn::Static, %w(/test), root: Dir.pwd)

  Tynn.define do
  end

  app = Tynn::Test.new
  app.get("/test/static_test.rb")

  assert_equal File.read(__FILE__), app.res.body
end
