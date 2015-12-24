require "bundler/setup"
require "minitest/autorun"
require "minitest/sugar"
require_relative "../lib/tynn"
require_relative "../lib/tynn/test"

class Tynn::TestCase < Minitest::Test
end
