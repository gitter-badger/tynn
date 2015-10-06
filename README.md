tynn [![Gem Version](https://badge.fury.io/rb/tynn.svg)](http://badge.fury.io/rb/tynn)
====

Simple library to create [Rack][rack] applications.

Description
-----------

Tynn is a very simple and very fast router for web applications inspired by
[Cuba][cuba] and [Syro][syro].

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

Installation
------------

```
$ gem install tynn
```

Contributing
------------

- Fork the project.
- Use `make install` to install dependencies.
- Use `make test` to run the test suite.
- Create a pull request with your changes.

You can install the gems globally, but we recommend [gs][gs] (or
[gst][gst] if you're using chruby) to keep things isolated.

[cuba]: https://github.com/soveran/cuba
[rack]: https://github.com/rack/rack
[syro]: https://github.com/soveran/syro
[gs]: https://github.com/soveran/gs
[gst]: https://github.com/tonchis/gst
