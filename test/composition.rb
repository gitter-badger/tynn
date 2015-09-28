require_relative "helper"

setup do
  Driver.new(Tynn)
end

test "composition" do |app|
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

  app.get("/foo")

  assert_equal 200, app.res.status
  assert_equal "42", app.res.body
end
