require_relative "helper"
require_relative "../lib/tynn/render"
require "tilt/erubis"

class RenderTest < Tynn::TestCase
  class App < Tynn
    plugin Tynn::Render, views: File.expand_path("views", __dir__)

    define do
      on("partial") do
        res.write(partial("partial", name: "alice"))
      end

      on("view") do
        res.write(view("view", title: "welcome", name: "alice"))
      end

      on("render") do
        render("view", title: "welcome", name: "alice")
      end

      on("escape") do
        res.write(partial("partial", name: "<a></a>"))
      end
    end
  end

  setup do
    @app = Tynn::Test.new(App)
  end

  test "partial" do
    @app.get("/partial")

    assert_equal "alice", @app.res.body.strip
  end

  test "view" do
    @app.get("/view")

    assert_equal "welcome / alice", @app.res.body.strip
  end

  test "render" do
    @app.get("/render")

    assert_equal "text/html", @app.res.content_type
    assert_equal "welcome / alice", @app.res.body.strip
  end

  test "escape by default" do
    @app.get("/escape")

    assert_equal "&lt;a&gt;&lt;/a&gt;", @app.res.body.strip
  end

  test "layout" do
    class CustomLayout < App
      set :layout, "custom_layout"

      define do
        get do
          render("view", title: "welcome", name: "alice")
        end
      end
    end

    app = Tynn::Test.new(CustomLayout)
    app.get("/")

    assert_equal "custom / welcome / alice", app.res.body.strip
  end
end
