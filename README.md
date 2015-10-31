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

Check [Getting Started][start] for more information.

Documentation
-------------

See our website: <http://tynn.xyz/>.

License
-------

Tynn is released under the [MIT License][mit].

[mit]: http://www.opensource.org/licenses/MIT
[start]: http://tynn.xyz/getting-started.html
[syro]: http://soveran.github.io/syro/
