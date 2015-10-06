require_relative "../lib/tynn/matchers"

setup do
  Tynn.helpers(Tynn::Matchers)

  Tynn::Test.new
end

test "default" do |app|
  Tynn.define do
    default do
      res.write("foo")
    end
  end

  app.get("/")

  assert_equal 200, app.res.status
  assert_equal "foo", app.res.body
end

test "param" do |app|
  Tynn.define do
    param(:foo) do |foo|
      res.write(foo)
    end

    param("bar") do |bar|
      res.write(bar)
    end
  end

  app.get("/", foo: "foo")

  assert_equal "foo", app.res.body

  app.get("/", foo: "bar")

  assert_equal "bar", app.res.body
end
