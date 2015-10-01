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

test "captures" do
  Tynn.define do
    on :foo do
      on :bar do
        res.write(sprintf("%s:%s", inbox[:foo], inbox[:bar]))
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
      res.write(inbox[:foo])
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

test "settings" do
  Tynn.settings[:message] = "hello"

  Tynn.define do
    get do
      res.write(settings[:message])
    end
  end

  app = Tynn::Test.new
  app.get("/")

  assert_equal "hello", app.res.body
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

scope "helpers" do
  module Helper
    def clean(str)
      return str.strip
    end

    module Number
      def self.setup(app, number)
        app.settings[:number] = number
      end

      def number
        return settings[:number]
      end
    end

    def self.setup(app, number = 1)
      app.helpers(Number, number)
    end

    module ClassMethods
      def foo
        "foo"
      end
    end
  end

  setup do
    Tynn::Test.new
  end

  test "helpers" do |app|
    Tynn.helpers(Helper)

    Tynn.define do
      get do
        res.write(clean(" foo "))
      end
    end

    app.get("/")

    assert_equal "foo", app.res.body
    assert_equal "foo", Tynn.foo
  end

  test "setup" do |app|
    Tynn.helpers(Helper)

    Tynn.define do
      res.write(number)
    end

    app.get("/")

    assert_equal "1", app.res.body
  end

  test "setup with arguments" do |app|
    Tynn.helpers(Helper, 2)

    Tynn.define do
      res.write(number)
    end

    app.get("/")

    assert_equal "2", app.res.body
  end
end
