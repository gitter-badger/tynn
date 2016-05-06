# frozen_string_literal: true

require "bundler/setup"
require "minitest/autorun"
require "minitest/sugar"
require "minitest/pride"
require_relative "../lib/tynn"
require_relative "../lib/tynn/test"

class Tynn
  class TestCase < Minitest::Test
    setup do
      Tynn.reset!
    end

    def new_app(parent = Tynn)
      Class.new(parent)
    end
  end
end
