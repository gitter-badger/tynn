# Testing

Tynn ships with [Tynn::Test][tynn-test], a simple helper class to simulate
requests to your application.

To use this plugin, you need `rack-test`:

```
$ gem install rack-test
```

[Tynn::Test][tynn-test] is test-framework agnostic. The following example
uses Minitest:

```ruby
require "minitest/autorun"
require "tynn/test"

class RoutesTest < Minitest::Test
  def setup
    @app = Tynn::Test.new
  end

  def test_home
    @app.get("/")

    assert_equal 200, app.res.status
    assert_equal "Hello World!", app.res.body
  end

  def test_signup
    @app.post("/signup", username: "bob", password: "secret")

    assert_equal 201, app.res.status
  end

  def test_auth
    @app.authorize("username", "password")

    @app.get("/")

    assert_equal "Welcome back!", app.res.body
  end
end
```

Check [Rack::Test][rack-test] for more information about usage.

[rack-test]: https://github.com/brynary/rack-test
[tynn-test]: /api/Tynn-Test.html
