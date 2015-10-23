unreleased
----------

- Add `Tynn::HSTS` extension. This allows advanced users to set the
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

- Remove `Tynn::Erubis` extension. Use `Tynn::Render` instead.

  ```ruby
  require "erubis"
  require "tynn"
  require "tynn/render"

  Tynn.helpers(Tynn::Render)
  ```

- Add `Tynn:HMote` extension to render HMote templates.
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

1.0.0.rc2
---------

- Public release.
