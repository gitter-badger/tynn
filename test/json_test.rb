require_relative "helper"
require_relative "../lib/tynn/json"

class JSONTest < Tynn::TestCase
  class App < Tynn
    plugin Tynn::JSON

    define do
      get do
        json(foo: "foo")
      end
    end
  end

  test "converts objects to json" do
    app = Tynn::Test.new(App)
    app.get("/")

    assert_equal "foo", JSON.parse(app.res.body)["foo"]
  end

  test "sets content type header" do
    app = Tynn::Test.new(App)
    app.get("/")

    assert_equal "application/json", app.res.content_type
  end
end
