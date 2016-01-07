Tynn [![Build Status](https://travis-ci.org/frodsan/tynn.svg)](https://travis-ci.org/frodsan/tynn)
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

See the website: <http://tynn.xyz/>.

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

License
-------

Tynn is released under the [MIT License][mit].

[contributing]: https://github.com/frodsan/tynn/blob/master/CONTRIBUTING.md
[mit]: http://www.opensource.org/licenses/MIT
[start]: http://tynn.xyz/tutorial.html
[syro]: http://soveran.github.io/syro/
