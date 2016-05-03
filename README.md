Tynn
====

A thin library for web development in Ruby.

* [Installation](#installation)
* [Testing](#testing)
* [Contributing](#contributing)
* [License](#license)

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem "tynn"
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install envoker
```

Testing
-------

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
uses [Minitest][minitest]:

```ruby
require "minitest/autorun"
require "tynn/test"

class GuestsRouteTest < Minitest::Test
  def setup
    @app = Tynn::Test.new
  end

  def test_home
    @app.get("/")

    assert_equal 200, @app.res.status
    assert_equal "Hello World!", @app.res.body
  end

  def test_signup
    @app.post("/signup", username: "bob", password: "secret")

    assert_equal 201, @app.res.status
  end
end
```

If this is not of your flavor, you can use any Rack-based
testing library or framework, like: [Rack::Test][rack-test]
or [Capybara][capybara].

[capybara]: https://github.com/jnicklas/capybara
[minitest]: https://github.com/seattlerb/minitest
[rack-test]: https://github.com/brynary/rack-test
[tynn-test]: https://github.com/frodsan/tynn/blob/master/lib/tynn/test.rb

Contributing
------------

Fork the project with:

```
$ git clone git@github.com:frodsan/tynn.git
```

To install dependencies, use:

```
$ bundle install
```

To run the test suite, do:

```
$ rake test
```

Use [GitHub Issues](https://github.com/frodsan/tynn/issues) for reporting
bugs, discussing features and general feedback.  If you've found a problem
in Tynn, be sure to check the [past issues](https://github.com/frodsan/tynn/issues?state=closed)
before open a new one. For new features, it's important to explain the use
case to solve, we want to keep the code base simple.

License
-------

Tynn is released under the [MIT License](http://www.opensource.org/licenses/MIT).
