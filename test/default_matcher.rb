require_relative "../lib/tynn/default_matcher"

test "default" do
  Tynn.helpers(Tynn::DefaultMatcher)

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
