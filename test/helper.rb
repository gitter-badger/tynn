# frozen_string_literal: true

require "bundler/setup"
require "minitest/autorun"
require "minitest/sugar"
require "minitest/pride"
require_relative "../lib/tynn"
require_relative "../lib/tynn/test"

class Minitest::Test
  def new_app(app = Tynn)
    Class.new(app)
  end
end
