# frozen_string_literal: true

require_relative "tynn/base"
require_relative "tynn/default_headers"
require_relative "tynn/errors"
require_relative "tynn/middleware"
require_relative "tynn/settings"
require_relative "tynn/version"

class Tynn
  # Loads given +plugin+ into the application.
  #
  # [plugin] A module that can contain a +ClassMethods+ or +InstanceMethods+
  #          module to extend Tynn. If +plugin+ responds to +setup+, it will
  #          be called last, and should be used to set up the plugin.
  # [*args]  A list of arguments passed to <tt>plugin#setup</tt>.
  # [&block] A block passed to <tt>plugin#setup</tt>.
  #
  #   # Using a default plugin
  #   require "tynn"
  #   require "tynn/environment"
  #   require "tynn/protection"
  #
  #   Tynn.plugin(Tynn::Environment)
  #   Tynn.plugin(Tynn::Protection, ssl: true)
  #
  #   # Using a custom plugin
  #   class MyAppNamePlugin
  #     def self.setup(app, name, &block)
  #       app.app_name = name
  #     end
  #
  #     module ClassMethods
  #       def app_name
  #         @app_name
  #       end
  #
  #       def app_name=(name)
  #         @app_name = name
  #       end
  #     end
  #
  #     module InstanceMethods
  #       def app_name
  #         self.class.app_name
  #       end
  #     end
  #   end
  #
  #   Tynn.plugin(MyAppNamePlugin, "MyApp")
  #
  def self.plugin(plugin, *args, &block)
    if defined?(plugin::InstanceMethods)
      include(plugin::InstanceMethods)
    end

    if defined?(plugin::ClassMethods)
      extend(plugin::ClassMethods)
    end

    if plugin.respond_to?(:setup)
      plugin.setup(self, *args, &block)
    end
  end

  plugin(Tynn::Base)
  plugin(Tynn::Middleware)
  plugin(Tynn::Settings)
  plugin(Tynn::DefaultHeaders)
end
