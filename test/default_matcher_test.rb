require_relative "../lib/tynn/default_matcher"

test "default" do |app|
  Tynn.plugin(Tynn::DefaultMatcher)

  Tynn.define do
    default do
      res.write("no escape")
    end
  end

  app = Tynn::Test.new
  app.get("/")

  assert_equal 200, app.res.status
  assert_equal "no escape", app.res.body
end
