class Tynn
  module Settings
    def self.deepclone(obj) # :nodoc:
      return Marshal.load(Marshal.dump(obj))
    end

    def settings
      return self.class.settings
    end

    module ClassMethods
      def inherited(subclass) # :nodoc:
        subclass.settings.replace(Tynn::Settings.deepclone(settings))
      end

      def settings
        return @settings ||= {}
      end
    end
  end
end
