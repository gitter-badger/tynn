unreleased
----------

- Remove `Tynn::Settings#settings`. Use the class method instead.

  ```
  # Before
  settings[:default_headers] # => {}

  # Now
  self.class.settings[:default_headers] # => {}
  ```

1.0.0.rc3 (26-10-2015)
----------------------

- `Tynn::helpers` only includes instance methods from `helper::InstanceMethods`.

  ```ruby
  # Before
  module Helper
    def helper
    end
  end

  # Now
  module Helper
    module InstanceMethods
      def helper
      end
    end
  end

  Tynn.helpers(Helper)
  ```

- Add `:force_ssl` option to enable/disable TLS redirect. Defaults to the
  same value as `:ssl`.

  ```ruby
  Tynn.helpers(Tynn::Protection, ssl: true, force_ssl: false)
  ```

- Rename `Tynn::SSL` to `Tynn::ForceSSL`.

- Add `Tynn::HSTS` helper. This allows advanced users to set the
  `Strict-Transport-Security` header separately. This helper is still
  included if the `:ssl` option in `Tynn::Protection` is `true`.

  ```ruby
  require "tynn"
  require "tynn/hsts"

  Tynn.helpers(Tynn::HSTS)
  ```

- Add ability to set default headers.

  ```ruby
  require "tynn"

  class API < Tynn
  end

  API.set(:default_headers, "Content-Type" => "application/json")
  ```

- Remove `Tynn::Erubis` helper. Use `Tynn::Render` instead.

  ```ruby
  require "erubis"
  require "tynn"
  require "tynn/render"

  Tynn.helpers(Tynn::Render)
  ```

- Add `Tynn:HMote` helper to render HMote templates.
  It's [x2 faster][hmote-bench] than Erubis and Tilt.

  ```ruby
  require "tynn"
  require "tynn/hmote"

  Tynn.helpers(Tynn::Hmote)
  ```

  Check [Tynn::HMote][hmote-docs] for more information.

- `Tynn::Render` enables HTML escaping by default if the template engine
  supports it. It's recommended to use `erubis` instead of `erb`:

  ```ruby
  # $ gem install erubis
  require "erubis"
  require "tynn"
  require "tynn/render"

  Tynn.helpers(Tynn::Render)
  ```

[hmote]: https://github.com/harmoni/hmote
[hmote-docs]: http://tynn.xyz/api/Tynn-HMote.html
[hmote-bench]: https://github.com/frodsan/tynn/blob/master/benchmarks/render.rb

1.0.0.rc2 (21-10-2015)
----------------------

- Public release.
