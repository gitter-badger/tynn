require_relative "../lib/tynn/options"

test "options" do
  Tynn.helpers(Tynn::Options)

  Tynn.define do
    options do
      res.write ""
    end
  end

  app = Tynn::Test.new
  app.options("/")

  assert_equal 200, app.res.status
end
