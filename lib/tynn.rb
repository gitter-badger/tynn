require "seteable"
require "syro"

class Tynn < Syro::Deck
  include Seteable

  require_relative "tynn/base"
  require_relative "tynn/version"

  def self.helpers(helper, *args, &block)
    self.include(helper)

    if defined?(helper::ClassMethods)
      self.extend(helper::ClassMethods)
    end

    if helper.respond_to?(:setup)
      helper.setup(self, *args, &block)
    end
  end

  helpers(Tynn::Base)
end
