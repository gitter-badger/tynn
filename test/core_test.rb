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
