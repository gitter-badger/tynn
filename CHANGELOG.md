2.0.0 (unreleased)
------------------

**3 Breaking changes:**

- Bump Syro version to 2.1.0. The functionality to yield the
  capture to the block has been removed in Syro. This version encourages the
  use of `inbox`.

  ```ruby
  # Before
  on(:id) do |id|
    res.write(id)
  end

  # Now
  on(:id) do
    res.write(inbox[:id])
  end
  ```

- Remove `Tynn::NotFound` plugin. The plugin performs bad. In
  the future, there will be a better support for handling errors and status
  codes.

- Remove `Tynn::AllMethods`. Syro 2.1.0 includes matchers for
  `HEAD` and `OPTIONS` by default.

**1 major feature:**

- `Tynn::SSL` always sets `secure` flag on cookies. This tells the browser to only
  transmit them over HTTPS.

**2 minor features:**

- Setting `hsts: false` now sets `hsts { expires: 0 }`. Sending this option
  disables HTTP Strict Transport Security.

  ```ruby
  # Before
  Tynn.plugin(Tynn::SSL, hsts: { expires: 0 })
  Tynn.plugin(Tynn::Protection, ssl: true, hsts: { expires: 0 })

  # Now
  Tynn.plugin(Tynn::SSL, hsts: false)
  Tynn.plugin(Tynn::Protection, ssl: true, hsts: false)
  ```

- Raise error if secret option for `Tynn::Session` is not provided:

  ```ruby
  Tynn.plugin(Tynn::Session)
  # => Tynn::Session::NoSecretError: No secret option provided.
  ```

**1 bug fix:**

- Fixes HTTPS redirect with non-default ports.

Please check [1.4.x](https://github.com/frodsan/tynn/blob/1.4.0/CHANGELOG.md)
for previous changes.
