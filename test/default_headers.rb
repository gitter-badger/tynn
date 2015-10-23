test "default headers" do
  Tynn.set(:default_headers, "Content-Type" => "text/plain")

  Tynn.define do
    root do
      res.write("hei")
    end
  end

  app = Tynn::Test.new(Tynn)
  app.get("/")

  assert_equal "text/plain", app.res.headers["Content-Type"]
end
