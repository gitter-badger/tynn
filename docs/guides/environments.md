# Environments

Tynn ships with [Tynn::Environment][environment] to set and check
the current environment.

```ruby
require "tynn"
require "tynn/environment"

Tynn.plugin(Tynn::Environment)

Tynn.environment
# => :development
```

The default value is `:development`. You can change it through the
`RACK_ENV` environment variable.

```ruby
ENV["RACK_ENV"].to_sym
# => :test

Tynn.environment
# => :test
```

You can use `development?`, `test?` and `production?` to check the current
environment.

```ruby
Tynn.plugin(Tynn::Protection, ssl: Tynn.production?)
```

[environment]: /api/Tynn-Environment.html
