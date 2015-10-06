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

test "settings are inheritable" do
  Tynn.settings[:message] = "hello"

  class API < Tynn
  end

  assert_equal "hello", API.settings[:message]
end

test "look up parent if setting not exists" do
  class Foo < Tynn
  end

  class Bar < Foo
  end

  Tynn.settings[:foo] = "foo"
  Foo.settings[:bar] = "bar"

  assert_equal "foo", Foo.settings[:foo]
  assert_equal "foo", Bar.settings[:foo]
  assert_equal "bar", Bar.settings[:bar]

  Bar.settings[:foo] = "bar"

  assert_equal "bar", Bar.settings[:foo]
end
