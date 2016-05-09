# frozen_string_literal: true

require_relative "helper"

class BaseTest < Minitest::Test
  test "raises if handler is not set" do
    assert_raises(Tynn::MissingHandlerError) do
      new_app.call({})
    end
  end

  test "hello" do
    app = new_app

    app.define do
      get do
        res.write("hello")
      end
    end

    ts = Tynn::Test.new(app)
    ts.get("/")

    assert_equal 200, ts.res.status
    assert_equal "hello", ts.res.body
  end

  test "http methods" do
    methods = %i(get post put patch delete head options)

    app = new_app

    methods.each do |method|
      app.define do
        send(method) { res.write "" }
      end

      ts = Tynn::Test.new(app)
      ts.send(method, "/")

      assert_equal 200, ts.res.status
    end
  end

  test "captures" do
    app = new_app

    app.define do
      on(:foo) do
        on(:bar) do
          res.write(sprintf("%{foo}:%{bar}", inbox))
        end
      end
    end

    ts = Tynn::Test.new(app)
    ts.get("/foo/bar")

    assert_equal 200, ts.res.status
    assert_equal "foo:bar", ts.res.body
  end

  test "composition" do
    app = new_app
    foo = new_app(app)

    app.define do
      on("foo") do
        run(foo, foo: 42)
      end
    end

    foo.define do
      get do
        res.write(inbox[:foo])
      end
    end

    ts = Tynn::Test.new(app)
    ts.get("/foo")

    assert_equal 200, ts.res.status
    assert_equal "42", ts.res.body
  end
end
