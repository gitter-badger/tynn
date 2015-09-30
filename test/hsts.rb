require_relative "helper"
require_relative "../lib/tynn/hsts"

test "hsts" do
  Tynn.helpers(Tynn::HSTS)

  Tynn.define do
  end

  app = Tynn::Test.new
  app.get("/")

  header = app.res.headers["Strict-Transport-Security"]

  assert_equal "max-age=15552000; includeSubdomains", header
end

test "hsts with options" do
  Tynn.helpers(Tynn::HSTS, max_age: 1, preload: true)

  Tynn.define do
  end

  app = Tynn::Test.new
  app.get("/")

  header = app.res.headers["Strict-Transport-Security"]

  assert_equal "max-age=1; includeSubdomains; preload", header
end
