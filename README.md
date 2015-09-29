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

Helpers
-------

```ruby
require "json"

module JSONHelpers
  def json(status, data)
    res.status = status
    res["Content-Type"] = "application/json"
    res.write(data.to_json)

    halt(res.finish)
  end
end

Tynn.helpers(JSONHelpers)
```

```ruby
Tynn.define do
  on("api") do
    root do
      json(200, name: "tynn", version: "1.0.0")
    end
  end
end
```

```ruby
module EnvironmentHelpers
  module ClassMethods
    def environment
      return ENV.fetch("RACK_ENV", "development").to_sym
    end

    def development?
      return environment == :development
    end

    def production?
      return environment == :production
    end
  end
end

Tynn.helpers(EnvironmentHelpers)

Tynn.environment  # => :development
Tynn.development? # => true
Tynn.production?  # => false
```

Examples
--------

- Reddit-like application: <https://github.com/harmoni/readit>

Installation
------------

```
$ gem install tynn
```

[cuba]: https://github.com/soveran/cuba
[rack]: https://github.com/rack/rack
[syro]: https://github.com/soveran/syro
