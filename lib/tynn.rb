require "syro"
require_relative "tynn/request"
require_relative "tynn/response"
require_relative "tynn/settings"
require_relative "tynn/version"

class Tynn
  include Syro::Deck::API

  # Public: Loads given +plugin+ into the application.
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/protection"
  #   require "tynn/session"
  #
  #   Tynn.plugin(Tynn::Protection)
  #   Tynn.plugin(Tynn::Session, secret: "__a_random_secret_key")
  #
  def self.plugin(plugin, *args, &block)
    if defined?(plugin::InstanceMethods)
      self.include(plugin::InstanceMethods)
    end

    if defined?(plugin::ClassMethods)
      self.extend(plugin::ClassMethods)
    end

    if plugin.respond_to?(:setup)
      plugin.setup(self, *args, &block)
    end
  end

  # Internal: Default plugins.
  plugin(Tynn::Settings)

  # Public: Sets the application handler.
  #
  # Examples
  #
  #   class Users < Tynn
  #   end
  #
  #   Users.define do
  #     on(:id) do |id|
  #       get do
  #         res.write("GET /users")
  #       end
  #
  #       post do
  #         res.write("POST /users")
  #       end
  #     end
  #   end
  #
  def self.define(&block)
    build_app(Syro.new(self, &block))
  end

  # Public: Adds given Rack +middleware+ to the stack.
  #
  # Examples
  #
  #   require "rack/common_logger"
  #   require "rack/show_exceptions"
  #
  #   Tynn.use(Rack::CommonLogger)
  #   Tynn.use(Rack::ShowExceptions)
  #
  def self.use(middleware, *args, &block)
    __middleware << proc { |app| middleware.new(app, *args, &block) }
  end

  def self.call(env) # :nodoc:
    return @app.call(env)
  end

  def self.build_app(syro) # :nodoc:
    if __middleware.empty?
      @app = syro
    else
      @app = __middleware.reverse.inject(syro) { |a, m| m.call(a) }
    end
  end

  def self.__middleware # :nodoc:
    return @middleware ||= []
  end

  def self.reset! # :nodoc:
    @app = nil
    @middleware = []
  end

  # Public: Sets an +option+ to the given +value+.
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/environment"
  #
  #   Tynn.plugin(Tynn::Environment)
  #
  #   Tynn.set(:environment, :staging)
  #   Tynn.environment
  #   # => :staging
  #
  def self.set(option, value)
    settings[option] = value
  end

  set(:default_headers, {})

  def default_headers # :nodoc:
    return Hash[self.class.settings[:default_headers]]
  end

  def request_class # :nodoc:
    return Tynn::Request
  end

  def response_class # :nodoc:
    return Tynn::Response
  end
end
