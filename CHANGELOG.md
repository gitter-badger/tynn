unreleased

- Add `Tynn:HMote` extension to render HMote. It renders x2 faster than using
  Erubis and Tilt.

  ```ruby
  require "tynn"
  require "tynn/hmote"

  Tynn.helpers(Tynn::Hmote)
  ```

  Check [Tynn::HMote] for more information.

[hmote]: https://github.com/harmoni/hmote
[hmote-docs]: http://tynn.xyz/api/Tynn-HMote.html
