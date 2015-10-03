require "seteable"
require "syro"

class Tynn < Syro::Deck
  include Seteable

  def self.define(&block)
    @syro = Syro.new(self, &block)
  end

  def self.use(_middleware, *args, &block)
    middleware << (Proc.new { |app| _middleware.new(app, *args, &block) })
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

  def self.call(env) # :nodoc:
    return to_app.call(env)
  end

  def self.to_app # :nodoc:
    fail("Missing application handler. Try #{ self }.define") unless @syro

    if middleware.empty?
      return @syro
    else
      return middleware.reverse.inject(@syro) { |a, m| m.call(a) }
    end
  end

  def self.middleware # :nodoc:
    return @middleware ||= []
  end

  def self.reset! # :nodoc:
    @syro = nil
    @middleware = []
  end
end

require_relative "tynn/version"
