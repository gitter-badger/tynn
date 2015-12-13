2.0.0 (unreleased)
------------------

- Raise error if secret option for `Tynn::Session` is not provided:

  ```ruby
  Tynn.plugin(Tynn::Session)
  # => Tynn::Session::NoSecretError: No secret option provided.
  ```

- Breaking change: Bump Syro version to 2.1.0. The functionality to yield the
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

- Breaking change: Remove Tynn::NotFound plugin. The plugin performs bad. In
  the future, there will be a better support for handling errors and status
  codes.

- Breaking change: Remove Tynn::AllMethods. Syro 2.1.0 includes matchers for
  `HEAD` and `OPTIONS` by default.

Please check [1.4.x](https://github.com/frodsan/tynn/blob/1.4.0/CHANGELOG.md)
for previous changes.
