# frozen_string_literal: true

require_relative "helper"

class MiddlewareTest < Minitest::Test
  class Shrimp
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      [status, headers, body.reverse]
    end
  end

  test "middleware in main application" do
    app = new_app

    app.use(Shrimp)

    app.define do
      get do
        res.write("1")
        res.write("2")
      end
    end

    ts = Tynn::Test.new(app)
    ts.get("/")

    assert_equal 200, ts.res.status
    assert_equal "21", ts.res.body
  end

  test "middleware with composition" do
    app = new_app
    api = new_app

    app.use(Shrimp)

    app.define do
      on("api") do
        run(api)
      end
    end

    api.define do
      get do
        res.write("1")
        res.write("2")
      end
    end

    ts = Tynn::Test.new(app)
    ts.get("/api")

    assert_equal 200, ts.res.status
    assert_equal "21", ts.res.body
  end

  test "middleware only in child application" do
    app = new_app
    api = new_app

    api.use(Shrimp)

    app.define do
      on("api") do
        run(api)
      end
    end

    api.define do
      get do
        res.write("1")
        res.write("2")
      end
    end

    ts = Tynn::Test.new(app)
    ts.get("/api")

    assert_equal 200, ts.res.status
    assert_equal "21", ts.res.body
  end
end
