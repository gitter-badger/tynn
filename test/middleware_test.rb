require_relative "helper"

class Shrimp
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    [status, headers, body.reverse]
  end
end

class MiddlewareTest < Tynn::TestCase
  test "middleware in main application" do
    Tynn.use(Shrimp)

    Tynn.define do
      get do
        res.write("1")
        res.write("2")
      end
    end

    app = Tynn::Test.new
    app.get("/")

    assert_equal 200, app.res.status
    assert_equal "21", app.res.body
  end

  test "middleware with composition" do
    Tynn.use(Shrimp)

    Tynn.define do
      on("api") do
        run(API)
      end
    end

    class API < Tynn
    end

    API.define do
      get do
        res.write("1")
        res.write("2")
      end
    end

    app = Tynn::Test.new
    app.get("/api")

    assert_equal 200, app.res.status
    assert_equal "21", app.res.body
  end

  test "middleware only in child application" do
    class APP < Tynn
      use(Shrimp)
    end

    Tynn.define do
      on("api") do
        run(APP)
      end
    end

    APP.define do
      get do
        res.write("1")
        res.write("2")
      end
    end

    app = Tynn::Test.new
    app.get("/api")

    assert_equal 200, app.res.status
    assert_equal "21", app.res.body
  end
end
