# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/tynn/json"

class JSONTest < Minitest::Test
  test "respond with json" do
    app = new_app

    app.plugin(Tynn::JSON)

    app.define do
      get do
        json(foo: "foo")
      end
    end

    ts = Tynn::Test.new(app)
    ts.get("/")

    assert_equal "foo", JSON.parse(ts.res.body)["foo"]
    assert_equal "application/json", ts.res.content_type
  end
end
