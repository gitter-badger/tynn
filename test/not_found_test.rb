# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/tynn/not_found"

class NotFoundTest < Tynn::TestCase
  class App < Tynn
    plugin(Tynn::NotFound)

    define {}

    def not_found
      res.write("not found")
    end
  end

  test "not found" do
    app = Tynn::Test.new(App)
    app.get("/notfound")

    assert_equal "not found", app.res.body
  end
end
