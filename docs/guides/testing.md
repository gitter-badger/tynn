# Testing

Tynn ships with [Tynn::Test][tynn-test], a simple helper class to simulate
requests to your application.

```ruby
require "tynn"
require "tynn/test"

Tynn.define do
  root do
    res.write("hei")
  end
end

app = Tynn::Test.new
app.get("/")

200   == app.res.status # => true
"hei" == app.res.body   # => true
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
```

If this is not of your flavor, you can use any Rack-based
testing library or framework, like: [Rack::Test][rack-test]
or [Capybara][capybara].

[capybara]: https://github.com/jnicklas/capybara
[cutest]: https://github.com/djanowski/cutest
[rack-test]: https://github.com/brynary/rack-test
[tynn-test]: /api/Tynn-Test.html
