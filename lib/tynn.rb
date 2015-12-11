require "syro"
require_relative "tynn/default_headers"
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

  # Public: Sets the application handler.
  #
  # Examples
  #
  #   class Users < Tynn
  #   end
  #
  #   Users.define do
  #     on(:id) do
  #       id = inbox[:id]
  #
  #       get do
  #         res.write("GET /users/#{ id }")
  #       end
  #
  #       post do
  #         res.write("POST /users/#{ id }")
  #       end
  #     end
  #   end
  #
  def self.define(&block)
    @__app = Syro.new(self, &block)

    unless middleware.empty?
      @__app = middleware.inject(@__app) { |a, m| m.call(a) }
    end
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
    self.middleware.unshift(Proc.new { |app| middleware.new(app, *args, &block) })
  end

  def self.call(env) # :nodoc:
    return @__app.call(env)
  end

  def self.middleware # :nodoc:
    return @__middleware ||= []
  end

  def self.reset! # :nodoc:
    @__app = nil
    @__middleware = []
  end

  def request_class # :nodoc:
    return Tynn::Request
  end

  def response_class # :nodoc:
    return Tynn::Response
  end

  plugin(Tynn::Settings)
  plugin(Tynn::DefaultHeaders)
end
