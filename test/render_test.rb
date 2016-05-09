# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/tynn/render"
require "tilt/erubis"

class RenderTest < Minitest::Test
  VIEWS_PATH = File.expand_path("views", __dir__)

  setup do
    @app = new_app

    @app.plugin(Tynn::Render, views: VIEWS_PATH)
  end

  test "partial" do
    @app.define do
      on("partial") do
        res.write(partial("partial", name: "alice"))
      end
    end

    ts = Tynn::Test.new(@app)
    ts.get("/partial")

    assert_equal "alice", ts.res.body.strip
  end

  test "view" do
    @app.define do
      on("view") do
        res.write(view("view", title: "welcome", name: "alice"))
      end
    end

    ts = Tynn::Test.new(@app)
    ts.get("/view")

    assert_equal "welcome / alice", ts.res.body.strip
  end

  test "render" do
    @app.define do
      on("render") do
        render("view", title: "welcome", name: "alice")
      end
    end

    ts = Tynn::Test.new(@app)
    ts.get("/render")

    assert_equal "text/html", ts.res.content_type
    assert_equal "welcome / alice", ts.res.body.strip
  end

  test "escape by default" do
    @app.define do
      on("escape") do
        res.write(partial("partial", name: "<a></a>"))
      end
    end

    ts = Tynn::Test.new(@app)
    ts.get("/escape")

    assert_equal "&lt;a&gt;&lt;/a&gt;", ts.res.body.strip
  end

  test "layout" do
    app = new_app
    app.plugin(Tynn::Render, views: VIEWS_PATH, layout: "custom_layout")

    app.define do
      get do
        render("view", title: "welcome", name: "alice")
      end
    end

    ts = Tynn::Test.new(app)
    ts.get("/")

    assert_equal "custom / welcome / alice", ts.res.body.strip
  end
end
