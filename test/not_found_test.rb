require_relative "../lib/tynn/not_found"

test "not found" do
  Tynn.plugin(Tynn::NotFound)

  class Tynn
    def not_found
      res.write("not found")
    end
  end

  Tynn.define do
  end

  app = Tynn::Test.new
  app.get("/notfound")

  assert_equal "not found", app.res.body
end
