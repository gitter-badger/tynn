require "bundler/setup"
require "minitest/autorun"
require "minitest/sugar"
require "minitest/pride"
require_relative "../lib/tynn"
require_relative "../lib/tynn/test"

class Tynn::TestCase < Minitest::Test
  setup do
    Tynn.reset!
  end
end
