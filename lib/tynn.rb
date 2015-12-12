require_relative "tynn/base"
require_relative "tynn/default_headers"
require_relative "tynn/settings"
require_relative "tynn/version"

class Tynn
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

  plugin(Tynn::Base)
  plugin(Tynn::Settings)
  plugin(Tynn::DefaultHeaders)
end
