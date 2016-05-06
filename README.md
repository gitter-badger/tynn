Tynn
====

A thin library for web development in Ruby.

* [Installation](#installation)
* [Environments](#environments)
* [Static Files](#static-files)
* [Testing](#testing)
* [API Reference](http://api.tynn.xyz/)
* [Changelog](#changelog)
* [Development](#development)
* [Contributing](#contributing)
* [Code Status](#code-status)
* [License](#license)

Installation
------------

```
$ gem install tynn
```

Environments
------------

Tynn ships with [Tynn::Environment] to set and check the current environment for the application.

```ruby
require "tynn"
require "tynn/environment"

Tynn.plugin(Tynn::Environment)
```

The default environment is based on the `RACK_ENV` environment variable.

```ruby
ENV["RACK_ENV"]
# => "test"

Tynn.environment
# => :test
```

If `ENV["RACK_ENV"]` is `nil`, the default value is `:development`.

```ruby
Tynn.environment
# => :development
```

To change the current environment, use the `environment=` method.

```ruby
Tynn.environment = :development

Tynn.environment
# => :development
```

To check the current environment, use: `development?`, `test?`,
`production?` or `staging?`.

```ruby
Tynn.plugin(Tynn::Protection, ssl: Tynn.production?)
```

Perform operations on specific environments with the `configure` method.

```ruby
Tynn.configure(:development) do
  use(Tynn::Static, %w(/js /css /images))
end

Tynn.configure(:production) do
  use(Tynn::SSL)
end
```

Static Files
------------

Tynn ships with [Tynn::Static][tynn-static] to serve static files such as images, CSS, JavaScript and others.

```ruby
require "tynn"
require "tynn/static"

Tynn.plugin(Tynn::Static, %w(/js /css /images))
```

By default, static files are served from the folder `public` in the current directory. You can specify a different location by passing the `:root` option:

```ruby
Tynn.plugin(Tynn::Static, %w(/js /css /images), root: "assets")
```

As you can see in the table below, the name of static directory is not included in the URL because the files are looked up relative to that directory.


| File                         | URL                                    |
| ---------------------------- | -------------------------------------- |
| ./public/js/application.js   | http://example.org/js/application.js   |
| ./public/css/application.css | http://example.org/css/application.css |
| ./public/images/logo.png     | http://example.org/images/logo.png     |

It's important to mention that the path of the static directory path is relative to the directory where you run the application. If you run the application from another directory, it's safer to use an absolute path:

```ruby
Tynn.plugin(
  Tynn::Static,
  %w(/js /css /images),
  root: File.expand_path("public", __dir__)
)
```

Testing
-------

Tynn ships with [Tynn::Test][tynn-test], a simple helper class to simulate requests to your application.

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

[Tynn::Test][tynn-test] is test-framework agnostic. The following example uses [Minitest][minitest]:

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

If this is not of your flavor, you can use any Rack-based testing library or framework, like: [Rack::Test][rack-test] or [Capybara][capybara].

Changelog
---------

To learn about new features, bug fixes, and changes, please refer to the [CHANGELOG](https://github.com/frodsan/tynn/blob/master/CHANGELOG.md).

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

Use [GitHub Issues](https://github.com/frodsan/tynn/issues) for reporting bugs, discussing features and general feedback. If you've found a problem in Tynn, be sure to check the [past issues](https://github.com/frodsan/tynn/issues?state=closed) before open a new one.

Code Status
-----------

[![Build Status](https://travis-ci.org/frodsan/tynn.svg?branch=master)](https://travis-ci.org/frodsan/tynn)

License
-------

Tynn is released under the [MIT License](http://www.opensource.org/licenses/MIT).

[capybara]: https://github.com/jnicklas/capybara
[minitest]: https://github.com/seattlerb/minitest
[rack-test]: https://github.com/brynary/rack-test
[Tynn::Environment]: http://api.tynn.xyz/Tynn/Environment.html
[tynn-static]: http://api.tynn.xyz/Tynn/Static.html
[tynn-test]: http://api.tynn.xyz/Tynn/Test.html
