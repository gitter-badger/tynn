require_relative "../lib/tynn/send_file"

test "file send" do
  Tynn.helpers(Tynn::SendFile)

  Tynn.define do
    root do
      send_file(__FILE__)
    end
  end

  app = Tynn::Test.new
  app.get("/")

  assert_equal File.read(__FILE__), app.res.body
end

test "file not exists" do
  Tynn.helpers(Tynn::SendFile)

  Tynn.define do
    root do
      send_file("notexists")
    end
  end

  app = Tynn::Test.new
  app.get("/")

  assert_equal 404, app.res.status
end
