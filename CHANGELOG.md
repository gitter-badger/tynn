2.0.0 (unreleased)
------------------

- Breaking change: Bump Syro version to 2.0.0.
  The functionality to yield the capture to the block
  has been removed in Syro. This version encourages the
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

- Raise error if secret option for `Tynn::Session` is not provided:

  ```ruby
  Tynn.plugin(Tynn::Session)
  # => Tynn::Session::NoSecretError: No secret option provided.
  ```

Please check [1.4.x](https://github.com/frodsan/tynn/blob/1.4.0/CHANGELOG.md)
for previous changes.
