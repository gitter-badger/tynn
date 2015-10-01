require "erb"
require_relative "../lib/tynn/render"

setup do
  Tynn.helpers(Tynn::Render, views: File.expand_path("./test/views"))

  Tynn::Test.new
end

test "partial" do |app|
  Tynn.define do
    on "partial" do
      res.write(partial("partial", name: "erb"))
    end
  end

  app.get("/partial")

  assert_equal "erb", app.res.body
end

test "view" do |app|
  Tynn.define do
    on "view" do
      res.write(view("view", title: "tynn", name: "erb"))
    end
  end

  app.get("/view")

  assert_equal "tynn / erb", app.res.body
end

test "render" do |app|
  Tynn.define do
    on "render" do
      render("view", title: "tynn", name: "erb")
    end
  end

  app.get("/render")

  assert_equal 200, app.res.status
  assert_equal "text/html", app.res.headers["Content-Type"]
  assert_equal "tynn / erb", app.res.body
end

test "404" do |app|
  Tynn.define do
    on "404" do
      res.status = 404

      render("view", title: "tynn", name: "erb")
    end
  end

  app.get("/404")

  assert_equal 404, app.res.status
  assert_equal "text/html", app.res.headers["Content-Type"]
  assert_equal "tynn / erb", app.res.body
end

test "custom layout" do
  class App < Tynn
    layout("custom_layout")
  end

  App.define do
    root do
      render("view", title: "tynn", name: "erb")
    end
  end

  app = Tynn::Test.new(App)
  app.get("/")

  assert_equal "custom / tynn / erb\n", app.res.body
end
