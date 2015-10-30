# Testing

Tynn ships with [Tynn::Test][tynn-test], a simple helper class to simulate
requests to your application.

To use this plugin, you need `rack-test`:

```
$ gem install rack-test
```

[Tynn::Test][tynn-test] is test-framework agnostic. The following example
uses [Cutest][cutest]:

```ruby
require "cutest"
require "tynn/test"

setup
  @app = Tynn::Test.new
end

test "home" do
  @app.get("/")

  assert_equal 200, app.res.status
  assert_equal "Hello World!", app.res.body
end

test "signup" do
  @app.post("/signup", username: "bob", password: "secret")

  assert_equal 201, app.res.status
end

test "auth" do
  @app.authorize("username", "password")

  @app.get("/")

  assert_equal "Welcome back!", app.res.body
end
```

Check [Rack::Test][rack-test] for more information about usage.

[cutest]: https://github.com/djanowski/cutest
[rack-test]: https://github.com/brynary/rack-test
[tynn-test]: /api/Tynn-Test.html
