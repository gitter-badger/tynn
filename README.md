Tynn
====

A thin library for web development in Ruby.

* [Installation](#installation)
* [Static Files](#static-files)
* [Testing](#testing)
* [Development](#development)
* [Contributing](#contributing)
* [Code Status](#code-status)
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
$ gem install tynn
```

Static Files
------------

Tynn ships with [Tynn::Static][tynn-static] to serve static files such as
images, CSS, JavaScript and others.

```ruby
require "tynn"
require "tynn/static"

Tynn.plugin(Tynn::Static, ["/js", "/css", "/images"])
```

By default, static files are served from the folder `public` in the current
directory. You can specify a different location by passing the `:root` option:

```ruby
Tynn.plugin(Tynn::Static, ["/js", "/css", "/images"], root: "assets")
```

As you can see in the table below, the name of static directory is not
included in the URL because the files are looked up relative to that
directory.


| File                         | URL                                    |
| ---------------------------- | -------------------------------------- |
| ./public/js/application.js   | http://example.org/js/application.js   |
| ./public/css/application.css | http://example.org/css/application.css |
| ./public/images/logo.png     | http://example.org/images/logo.png     |

It's important to mention that the path of the static directory path is
relative to the directory where you run the application. If you run the
application from another directory, it's safer to use an absolute path:

```ruby
Tynn.plugin(
  Tynn::Static,
  ["/js", "/css", "/images"],
  root: File.expand_path("public", __dir__)
)
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
    assert_equal "text/html", @app.res["Content-Type"]
  end
end
```

If this is not of your flavor, you can use any Rack-based
testing library or framework, like: [Rack::Test][rack-test]
or [Capybara][capybara].

Development
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

Contributing
------------

Use [GitHub Issues](https://github.com/frodsan/tynn/issues) for reporting
bugs, discussing features and general feedback.  If you've found a problem
in Tynn, be sure to check the [past issues](https://github.com/frodsan/tynn/issues?state=closed)
before open a new one.

Code Status
-----------

[![Build Status](https://travis-ci.org/frodsan/tynn.svg?branch=master)](https://travis-ci.org/frodsan/tynn)

License
-------

Tynn is released under the [MIT License](http://www.opensource.org/licenses/MIT).

[capybara]: https://github.com/jnicklas/capybara
[minitest]: https://github.com/seattlerb/minitest
[rack-test]: https://github.com/brynary/rack-test
[tynn-static]: https://github.com/frodsan/tynn/blob/master/lib/tynn/static.rb
[tynn-test]: https://github.com/frodsan/tynn/blob/master/lib/tynn/test.rb
