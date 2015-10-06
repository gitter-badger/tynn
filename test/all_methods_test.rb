require_relative "../lib/tynn/all_methods"

Tynn.helpers(Tynn::AllMethods)

test "methods" do
  [:head, :options].each do |method|
    Tynn.define do
      send(method) { res.write "" }
    end

    app = Tynn::Test.new
    app.send(method, "/")

    assert_equal 200, app.res.status
  end
end
