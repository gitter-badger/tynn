Contributing
============

Setting up the Project
----------------------

Fork the project with:

```
$ git clone git@github.com:frodsan/tynn.git
```

To install dependencies, use:

```
$ make install
```

To run the test suite, execute:

```
$ make test
```

You can install the gems globally, but we recommend [gs][gs] (or
[gst][gst] if you're using chruby) to keep things isolated. Also,
a `Gemfile` is included for Bundler users.

[gs]: https://github.com/soveran/gs
[gst]: https://github.com/tonchis/gst

Documentation
-------------

If you want to build the [documentation](http://tynn.xyz) locally, there are some tasks to generate it:

```
make pages  # Generate pages
make rdoc   # Generate API docs
make server # Run documentation server on localhost, port 4000
```

The dependencies are listed in `.gems.doc`, you can install it with:

```
$ cat .gems.docs | xargs gem install
```

Issues / Patches
----------------

Please, review <http://tynn.xyz/development.html>.

Last words
----------

Thank YOU! :heart: :heart: :heart:

[pulls]: https://github.com/frodsan/tynn/pulls
