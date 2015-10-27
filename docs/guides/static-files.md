# Serving Static Files

Tynn ships with [Tynn::Static][static] to serve static files such as
images, CSS, JavaScript and others.

```ruby
require "tynn"
require "tynn/static"

Tynn.helpers(Tynn::Static, ["/js", "/css", "/images"])
```

By default, static files are served from the folder `public` in the current
directory. You can specify a different location by passing the `:root` option:

```ruby
Tynn.helpers(Tynn::Static, ["/js", "/css", "/images"], root: "assets")
```

As you can see in the table below, the name of static directory is not
included in the URL because the files are looked up relative to that
directory.


| File                         | URL                                       |
| ---------------------------- | ----------------------------------------- |
| ./public/js/application.js   | http://localhost:9292/js/application.js   |
| ./public/css/application.css | http://localhost:9292/css/application.css |
| ./public/images/logo.png     | http://localhost:9292/images/logo.png     |

It's important to mention that the path of the static directory path is
relative to the directory where you run the application. If you run the
application from another directory, it's safer to use an absolute path:

```ruby
Tynn.helpers(
  Tynn::Static,
  ["/js", "/css", "/images"],
  root: File.expand_path("public", __dir__)
)
```

[static]: /api/Tynn-Static.html