require_relative "../lib/tynn/erubis"

setup do
  Tynn.helpers(Tynn::Erubis, views: File.expand_path("./test/views"))

  Tynn::Test.new
end

test "escapes" do |app|
  Tynn.define do
    root do
      res.write(partial("partial", name: "<a></a>"))
    end
  end

  app = Tynn::Test.new
  app.get("/")

  assert_equal "&lt;a&gt;&lt;/a&gt;", app.res.body.strip
end
