require_relative "helper"

test "use settings inside the application" do
  Tynn.settings[:message] = "hello"

  Tynn.define do
    get do
      res.write(settings[:message])
    end
  end

  app = Tynn::Test.new
  app.get("/")

  assert_equal "hello", app.res.body
end

test "settings are inheritable and overridable" do
  Tynn.settings[:foo] = "bar"

  class Admin < Tynn; end

  assert_equal "bar", Admin.settings[:foo]

  Admin.settings[:foo] = "baz"

  assert_equal "bar", Tynn.settings[:foo]
  assert_equal "baz", Admin.settings[:foo]
end
