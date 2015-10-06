test "hello" do
  Tynn.define do
    get do
      res.write("hello")
    end
  end

  app = Tynn::Test.new
  app.get("/")

  assert_equal 200, app.res.status
  assert_equal "hello", app.res.body
end

test "methods" do
  [:get, :post, :put, :patch, :delete].each do |method|
    Tynn.define do
      send(method) { res.write "" }
    end

    app = Tynn::Test.new
    app.send(method, "/")

    assert_equal 200, app.res.status
  end
end

test "captures" do
  Tynn.define do
    on :foo do |foo|
      on :bar do |bar|
        res.write(sprintf("%s:%s", foo, bar))
      end
    end
  end

  app = Tynn::Test.new
  app.get("/foo/bar")

  assert_equal 200, app.res.status
  assert_equal "foo:bar", app.res.body
end

test "composition" do
  class Foo < Tynn
  end

  Foo.define do
    get do
      res.write(vars[:foo])
    end
  end

  Tynn.define do
    on "foo" do
      run(Foo, foo: 42)
    end
  end

  app = Tynn::Test.new
  app.get("/foo")

  assert_equal 200, app.res.status
  assert_equal "42", app.res.body
end

test "raise unless application handler is set" do
  app = Tynn::Test.new

  assert_raise(RuntimeError) do
    app.get("/")
  end
end

scope "middleware" do
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

    app = Tynn::Test.new
    app.get("/api")

    assert_equal 200, app.res.status
    assert_equal "21", app.res.body
  end

  test "middleware only in child application" do
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

    app = Tynn::Test.new
    app.get("/api")

    assert_equal 200, app.res.status
    assert_equal "21", app.res.body
  end
end
