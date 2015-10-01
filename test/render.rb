require "erb"
require_relative "../lib/tynn/render"

Tynn.helpers(Tynn::Render, views: File.expand_path("./test/views"))

Tynn.define do
  on "partial" do
    res.write(partial("partial", name: "bob"))
  end

  on "view" do
    res.write(view("view", title: "tynn", name: "bob"))
  end

  on "render" do
    render("view", title: "tynn", name: "bob")
  end

  on "404" do
    res.status = 404

    render("view", title: "tynn", name: "bob")
  end
end

setup do
  Tynn::Test.new
end

test "partial" do |app|
  app.get("/partial")

  assert_equal "bob", app.res.body
end

test "view" do |app|
  app.get("/view")

  assert_equal "tynn / bob", app.res.body
end

test "render" do |app|
  app.get("/render")

  assert_equal 200, app.res.status
  assert_equal "text/html", app.res.headers["Content-Type"]
  assert_equal "tynn / bob", app.res.body
end

test "404" do |app|
  app.get("/404")

  assert_equal 404, app.res.status
  assert_equal "text/html", app.res.headers["Content-Type"]
  assert_equal "tynn / bob", app.res.body
end
