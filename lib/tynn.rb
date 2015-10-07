require "seteable"
require "syro"

class Tynn < Syro::Deck
  include Seteable

  def self.define(&block)
    @syro = Syro.new(self, &block)
  end

  # Adds given Rack `middleware` to the stack.
  #
  #     require "rack/show_exceptions"
  #
  #     class ForceSSL
  #       def initialize(app)
  #         @app = app
  #       end
  #
  #       def call(env)
  #         request = Rack::Request.new(env)
  #
  #         unless request.ssl?
  #           return [301, { "Location" => "https://safe.app" }, []]
  #         end
  #
  #         return @app.call(env)
  #       end
  #     end
  #
  #     Tynn.use(ForceSSL)
  #     Tynn.use(Rack::ShowExceptions)
  #
  def self.use(middleware, *args, &block)
    __middleware << proc { |app| middleware.new(app, *args, &block) }
  end

  def self.call(env) # :nodoc:
    return to_app.call(env)
  end

  def self.to_app # :nodoc:
    fail("Missing application handler. Try #{ self }.define") unless @syro

    if __middleware.empty?
      return @syro
    else
      return __middleware.reverse.inject(@syro) { |a, m| m.call(a) }
    end
  end

  def self.__middleware # :nodoc:
    return @middleware ||= []
  end

  def self.reset! # :nodoc:
    @syro = nil
    @middleware = []
  end

  def self.helpers(helper, *args, &block)
    self.include(helper)

    if defined?(helper::ClassMethods)
      self.extend(helper::ClassMethods)
    end

    if helper.respond_to?(:setup)
      helper.setup(self, *args, &block)
    end
  end
end

require_relative "tynn/version"
