class Tynn
  module Settings
    def self.deepclone(hash) # :nodoc:
      default_proc, hash.default_proc = hash.default_proc, nil

      return Marshal.load(Marshal.dump(hash))
    ensure
      hash.default_proc = default_proc
    end

    def settings
      return self.class.settings
    end

    module ClassMethods
      def inherited(subclass) # :nodoc:
        subclass.settings.replace(Tynn::Settings.deepclone(settings))
        subclass.settings.default_proc = proc { |h, k| h[k] = settings[k] }
      end

      def settings
        return @settings ||= {}
      end
    end
  end
end
