class Tynn
  # Public: It provides a settings API for applications. This helper is
  # included by default.
  #
  # Examples
  #
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
  #   Tynn.helpers(AppName, "MyApp")
  #
  #   Tynn.app_name
  #   # => "MyApp"
  #
  module Settings
    # Internal: Returns a deep copy of a Hash.
    def self.deepclone(hash)
      default_proc, hash.default_proc = hash.default_proc, nil

      return Marshal.load(Marshal.dump(hash))
    ensure
      hash.default_proc = default_proc
    end

    module ClassMethods
      # Internal: Copies settings into the subclass.
      # If a setting is not found, checks parent's settings.
      def inherited(subclass)
        subclass.settings.replace(Tynn::Settings.deepclone(settings))
        subclass.settings.default_proc = proc { |h, k| h[k] = settings[k] }
      end

      # Returns a Hash with the application settings.
      #
      # Examples
      #
      #   Tynn.set(:environment, :development)
      #
      #   Tynn.settings
      #   # => { :environment => :development }
      #
      def settings
        return @settings ||= {}
      end
    end
  end
end
