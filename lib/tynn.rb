# frozen_string_literal: true

require_relative "tynn/base"
require_relative "tynn/default_headers"
require_relative "tynn/errors"
require_relative "tynn/middleware"
require_relative "tynn/settings"
require_relative "tynn/version"

class Tynn
  # Loads given `plugin` into the application.
  #
  # @param plugin A module that can contain a `ClassMethods` or `InstanceMethods`
  #   module to extend Tynn. If `plugin` responds to `setup`, it will be called
  #   last, and should be used to set up the plugin.
  # @param *args A list of arguments passed to `plugin#setup`
  # @param &block A block passed to `plugin#setup`
  #
  # @example Using a default plugin
  #   require "tynn"
  #   require "tynn/environment"
  #   require "tynn/protection"
  #
  #   Tynn.plugin(Tynn::Environment)
  #   Tynn.plugin(Tynn::Protection, ssl: true)
  #
  # @example Using a custom plugin
  #   class MyAppNamePlugin
  #     def self.setup(app, name, &block)
  #       settings[:app_name] = name
  #     end
  #
  #     module ClassMethods
  #       def app_name
  #         return settings[:app_name]
  #       end
  #     end
  #
  #     module InstanceMethods
  #       def app_name
  #         return self.class.app_name
  #       end
  #     end
  #   end
  #
  #   Tynn.plugin(MyAppNamePlugin, "MyApp")
  #
  # @return [void]
  #
  # @see http://tynn.xyz/plugins.html
  #
  def self.plugin(plugin, *args, &block)
    include(plugin::InstanceMethods) if defined?(plugin::InstanceMethods)

    extend(plugin::ClassMethods) if defined?(plugin::ClassMethods)

    plugin.setup(self, *args, &block) if plugin.respond_to?(:setup)
  end

  plugin(Tynn::Base)
  plugin(Tynn::Middleware)
  plugin(Tynn::Settings)
  plugin(Tynn::DefaultHeaders)
end
