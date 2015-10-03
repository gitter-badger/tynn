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

test "param?" do |app|
  Tynn.define do
    on param?(:key) do
      res.write(req[:key])
    end
  end

  app.get("/")

  assert_equal 404, app.res.status

  app.get("/", key: "foo")

  assert_equal 200, app.res.status
  assert_equal "foo", app.res.body
end
