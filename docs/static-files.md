# Static Files

Tynn ships with [Tynn::Static][static] to serve static files, such as
images, CSS, JavaScript, etc.

```ruby
require "tynn"
require "tynn/static"

Tynn.helpers(Tynn::Static, ["/js", "/css", "/images"])
```

By default, static files are served from the folder `public` in the current
directory.

| File                         | URL                                       |
| ---------------------------- | ----------------------------------------- |
| ./public/js/application.js   | http://localhost:9292/js/application.js   |
| ./public/css/application.css | http://localhost:9292/css/application.css |
| ./public/images/logo.png     | http://localhost:9292/images/logo.png     |

As you can see above, the name of static directory is not included in the URL
because the files are looked up relative to that directory.

[static]: /api/Tynn-Static.html
