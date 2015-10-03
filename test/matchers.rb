require_relative "../lib/tynn/matchers"

setup do
  Tynn.helpers(Tynn::Matchers)
end

test "default" do
  Tynn.define do
    default do
      res.write("foo")
    end
  end

  app = Tynn::Test.new
  app.get("/")

  assert_equal 200, app.res.status
  assert_equal "foo", app.res.body
end
