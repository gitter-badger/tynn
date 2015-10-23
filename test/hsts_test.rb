require_relative "../lib/tynn/hsts"

test "hsts header" do |app|
  Tynn.helpers(Tynn::HSTS)

  Tynn.define do
  end

  app = Tynn::Test.new
  app.get("/", {})

  header = app.res.headers["Strict-Transport-Security"]

  assert_equal "max-age=15552000; includeSubdomains", header
end

test "hsts header options" do |app|
  Tynn.helpers(Tynn::HSTS, expires: 1, subdomains: false, preload: true)

  Tynn.define do
  end

  app = Tynn::Test.new
  app.get("/", {})

  header = app.res.headers["Strict-Transport-Security"]

  assert_equal "max-age=1; preload", header
end
