<h1 style="display: none">A thin library for web development.</h1>

tynn [![Build Status](https://travis-ci.org/frodsan/tynn.svg)](https://travis-ci.org/frodsan/tynn)
====

A thin library for web development.

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

Check [Getting Started](/getting-started.html) for more information.

[syro]: http://soveran.github.io/syro/
