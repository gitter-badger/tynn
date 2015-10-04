require "rack"
require_relative "tynn/base"
require_relative "tynn/settings"
require_relative "tynn/version"

class Tynn
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
  helpers(Tynn::Settings)
end
