module Tynn::Base
  def vars
    return inbox
  end

  module ClassMethods
    def define(&block)
      @syro = Syro.new(self, &block)
    end

    def use(_middleware, *args, &block)
      middleware << (Proc.new { |app| _middleware.new(app, *args, &block) })
    end

    def call(env) # :nodoc:
      return to_app.call(env)
    end

    def to_app # :nodoc:
      fail("Missing application handler. Try #{ self }.define") unless @syro

      if middleware.empty?
        return @syro
      else
        return middleware.reverse.inject(@syro) { |a, m| m.call(a) }
      end
    end

    def middleware # :nodoc:
      return @middleware ||= []
    end

    def reset! # :nodoc:
      @syro = nil
      @middleware = []
    end
  end
end
