require_relative "helper"

class Shrimp
  def initialize(app)
    @app = app
  end

  def call(env)
    s, h, resp = @app.call(env)

    return [s, h, resp.reverse]
  end
end

setup do
  Tynn.reset!
end

test "use middleware in main application" do
  Tynn.use(Shrimp)

  Tynn.define do
    get do
      res.write("1")
      res.write("2")
    end
  end

  app = Driver.new(Tynn)
  app.get("/")

  assert_equal 200, app.res.status
  assert_equal "21", app.res.body
end

test "use middleware with composition" do
  Tynn.use(Shrimp)

  Tynn.define do
    on "api" do
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

  app = Driver.new(Tynn)
  app.get("/api")

  assert_equal 200, app.res.status
  assert_equal "21", app.res.body
end

test "use middleware only in child application" do
  Tynn.define do
    on "api" do
      run(API)
    end
  end

  class API < Tynn
    use(Shrimp)
  end

  API.define do
    get do
      res.write("1")
      res.write("2")
    end
  end

  app = Driver.new(Tynn)

  app.get("/api")

  assert_equal 200, app.res.status
  assert_equal "21", app.res.body
end
