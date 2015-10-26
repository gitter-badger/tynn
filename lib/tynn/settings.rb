class Tynn
  module Settings # :nodoc:
    def self.deepclone(hash)
      default_proc, hash.default_proc = hash.default_proc, nil

      return Marshal.load(Marshal.dump(hash))
    ensure
      hash.default_proc = default_proc
    end

    module ClassMethods # :nodoc:
      def inherited(subclass)
        subclass.settings.replace(Tynn::Settings.deepclone(settings))
        subclass.settings.default_proc = proc { |h, k| h[k] = settings[k] }
      end

      def settings
        return @settings ||= {}
      end
    end
  end
end
