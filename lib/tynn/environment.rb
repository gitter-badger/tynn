# Adds helper methods to get and check the current environment.
#
#     require "tynn"
#     require "tynn/environment"
#
#     Tynn.helpers(Tynn::Environment)
#
#     Tynn.environment  # => :development
#
#     Tynn.development? # => true
#     Tynn.production?  # => false
#     Tynn.test?        # => false
#
# By default, the environment is based on `ENV["RACK_ENV"]`.
#
#     Tynn.helpers(Tynn::Environment, env: ENV["RACK_ENV"])
#
module Tynn::Environment
  def self.setup(app, env: ENV["RACK_ENV"]) # :nodoc:
    app.settings[:environment] = (env || :development).to_sym
  end

  module ClassMethods # :nodoc:
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
