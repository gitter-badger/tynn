require_relative "helper"

test "hello" do
  Tynn.define do
    get do
      res.write("hello")
    end
  end

  app = Driver.new(Tynn)
  app.get("/")

  assert_equal 200, app.res.status
  assert_equal "hello", app.res.body
end
