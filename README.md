Tynn [![Build Status](https://travis-ci.org/frodsan/tynn.svg)](https://travis-ci.org/frodsan/tynn)
====

A thin library for web development.

Description
-----------

Tynn is a thin abstraction on top of [Syro][syro], a very simple and fast
router for web applications.

Getting Started
---------------

1. Install Tynn if you haven't yet:

  ```
  $ gem install tynn
  ```

2. Here is a simple application. Save the contents as *config.ru*.

  ```ruby
  # config.ru
  require "tynn"

  Tynn.define do
    get do
      res.write("Hello World!")
    end
  end

  run(Tynn)
  ```

3. Start the web server with:

  ```
  $ rackup
  ```

4. Visit <http://localhost:9292> and you'll see the greeting message.

5. Check the [tutorial](http://tynn.xyz/tutorial.html), the [guides](http://tynn.xyz),
   and the [API documentation](http://rdoc.info/github/frodsan/tynn/master) for
   more information.

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

Use [GitHub Issues][issues] for reporting bugs, discussing features and
general feedback.  If you've found a problem in Tynn, be sure to check
the [past issues](https://github.com/frodsan/tynn/issues?state=closed)
before open a new one. For new features, it's important to explain the
use case to solve, we want to keep the code base simple.

License
-------

Tynn is released under the [MIT License][mit].

[contributing]: https://github.com/frodsan/tynn/blob/master/CONTRIBUTING.md
[issues]: https://github.com/frodsan/tynn/issues
[mit]: http://www.opensource.org/licenses/MIT
[start]: http://tynn.xyz/tutorial.html
[syro]: http://soveran.github.io/syro/
