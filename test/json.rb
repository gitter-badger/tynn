require_relative "../lib/tynn/json"

test "json" do
  Tynn.helpers(Tynn::JSON)

  Tynn.define do
    root do
      json(name: "tynn")
    end
  end

  app = Tynn::Test.new
  app.get("/")

  json = JSON.parse(app.res.body)

  assert_equal "tynn", json["name"]
  assert_equal "application/json", app.res.headers["Content-Type"]
end
