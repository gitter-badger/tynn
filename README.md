tynn
====

Simple library to create [Rack][rack] applications.

Description
-----------

Tynn is a thin abstraction on top of [Syro][syro], a very simple and fast
router for web applications.

Usage
-----

Here's a minimal application:

```ruby
# config.ru
require "tynn"

Tynn.define do
  root do
    res.write("Hello World!")
  end
end

run(Tynn)
```

You can run `rackup` and open <http://localhost:9292/> to see the greeting
message.

Contributing
------------

- Fork the project.
- Use `make install` to install dependencies.
- Use `make test` to run the test suite.
- Create a pull request with your changes.

Installation
------------

```
$ gem install tynn
```

[cuba]: https://github.com/soveran/cuba
[rack]: https://github.com/rack/rack
[syro]: https://github.com/soveran/syro
