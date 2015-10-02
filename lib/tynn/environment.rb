module Tynn::Environment
  def self.setup(app, env: ENV["RACK_ENV"]) # :nodoc:
    app.settings[:environment] = (env || :development).to_sym
  end

  module ClassMethods
    def environment
      return settings[:environment]
    end

    def development?
      return environment == :development
    end

    def test?
      return environment == :test
    end

    def production?
      return environment == :production
    end
  end
end
