# frozen_string_literal: true

class Tynn
  # It provides a settings API for applications.
  # This plugin is included by default.
  #
  # @example
  #   require "tynn"
  #
  #   module AppName
  #     def self.setup(app, app_name)
  #       app.settings[:app_name] = app_name
  #     end
  #
  #     module ClassMethods
  #       def app_name
  #         return settings[:app_name]
  #       end
  #     end
  #   end
  #
  #   Tynn.plugin(AppName, "MyApp")
  #
  #   Tynn.app_name
  #   # => "MyApp"
  #
  module Settings
    # @private
    def self.deepclone(hash)
      default_proc, hash.default_proc = hash.default_proc, nil

      return Marshal.load(Marshal.dump(hash))
    ensure
      hash.default_proc = default_proc
    end

    module ClassMethods
      # @private Copies settings into the subclass. If a setting is not found,
      # checks parent's settings.
      def inherited(subclass)
        subclass.settings.replace(Tynn::Settings.deepclone(settings))
        subclass.settings.default_proc = proc { |h, k| h[k] = settings[k] }
      end

      # Returns a Hash with the application settings.
      #
      # @example
      #   Tynn.set(:environment, :development)
      #
      #   Tynn.settings
      #   # => { :environment => :development }
      #
      # @return [Hash] application settings.
      #
      def settings
        @settings ||= {}
      end

      # Sets an `option` to the given `value`.
      #
      # @example
      #   Tynn.set(:environment, :staging)
      #
      #   Tynn.settings[:environment]
      #   # => :staging
      #
      # @return [void]
      #
      def set(option, value)
        settings[option] = value
      end
    end

    module InstanceMethods
      # Returns a Hash with the application settings.
      #
      # @example
      #   Tynn.set(:environment, :development)
      #
      #   Tynn.define do
      #     get do
      #       res.write(settings[:environment])
      #     end
      #   end
      #
      #   # GET / # => 200 "development"
      #
      # @return (see Tynn::Settings::ClassMethods#settings)
      #
      def settings
        self.class.settings
      end
    end
  end
end
