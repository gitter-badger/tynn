# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/tynn/not_found"

class NotFoundTest < Minitest::Test
  test "not found" do
    app = new_app

    app.plugin(Tynn::NotFound)

    app.define {}

    app.class_eval do
      def not_found
        res.write("not found")
      end
    end

    ts = Tynn::Test.new(app)
    ts.get("/notfound")

    assert_equal "not found", ts.res.body
  end
end
