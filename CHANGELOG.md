unreleased
----------

- Add `Tynn:HMote` extension to render HMote templates.
  It's x2 faster than Erubis and Tilt.

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
