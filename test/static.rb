require_relative "helper"
require_relative "../lib/tynn/static"

test "static" do
  Tynn.helpers(Tynn::Static, %w(/test), root: Dir.pwd)

  Tynn.define do
  end

  app = Driver.new(Tynn)
  app.get("/test/static.rb")

  assert_equal File.read(__FILE__), app.res.body
end
