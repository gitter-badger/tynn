require_relative "../lib/tynn/json_parser"

headers = {
  "CONTENT_TYPE" => "application/json"
}

test "json body parse" do
  Tynn.helpers(Tynn::JSONParser)

  params = { "foo" => "foo" }

  Tynn.define do
    root do
      res.write(JSON.generate(req.params))
    end
  end

  app = Tynn::Test.new(Tynn)
  app.post("/", JSON.generate(params), headers)

  assert_equal params, JSON.parse(app.res.body)
end
