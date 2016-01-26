2.0.0 (unreleased)
------------------

**3 Breaking changes:**

- Tynn 2 will only support versions of Ruby greater than 2.3.0.

- Bump Syro version to 2.1.0. The functionality to yield the
  capture to the block has been removed in Syro. This version
  encourages the use of `inbox`.

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

- Remove `Tynn::AllMethods`. Syro 2.1.0 includes matchers for
  `HEAD` and `OPTIONS` by default.

**2 new features:**

- Add `#staging?` method to `Tynn::Environment`. Returns `true` if `environment`
  is `:staging`. Otherwise, returns `false`.

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

**4 enhancements:**

- `Tynn::SSL` always sets `secure` flag on cookies. This tells the browser to only
  transmit them over HTTPS.

- `Tynn::SSL` always executes before other middleware.

- Raise error if application handler is missing:

  ```ruby
  run(App)
  # => Application handler is missing. Try App.define { }
  ```

- Raise error if secret option for `Tynn::Session` is not provided:

  ```ruby
  Tynn.plugin(Tynn::Session)
  # => No secret option provided.
  ```

**1 bug fix:**

- Fixes HTTPS redirect with non-default ports.

Please check [1.4.x](https://github.com/frodsan/tynn/blob/1.4.0/CHANGELOG.md)
for previous changes.
