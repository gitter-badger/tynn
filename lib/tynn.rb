require "seteable"
require "syro"

class Tynn < Syro::Deck
  include Seteable

  def self.call(env)
    return to_app.call(env)
  end

  def self.to_app
    if __middleware.empty?
      return @__syro
    else
      return __middleware.inject(@__syro) { |a, m| m.call(a) }
    end
  end

  def self.__middleware
    return @__middleware ||= []
  end

  def self.define(&block)
    @__syro = Syro.new(self, &block)
  end

  def self.use(middleware, *args, &block)
    __middleware.unshift(Proc.new { |app| middleware.new(app, *args, &block) })
  end

  def self.helpers(helper, *args)
    self.include(helper)

    if defined?(helper::ClassMethods)
      self.extend(helper::ClassMethods)
    end

    if helper.respond_to?(:setup)
      helper.setup(self, *args)
    end
  end
end

require_relative "tynn/version"
