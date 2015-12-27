class Tynn
  # Adds helper methods to get and check the current environment.
  # By default, the environment is based on `ENV["RACK_ENV"]`.
  #
  # @example Setting up the plugin
  #   require "tynn"
  #   require "tynn/environment"
  #
  #   Tynn.plugin(Tynn::Environment)
  #
  # @example Accessing the current environment
  #   Tynn.environment  # => :development
  #
  # @example Check the current environment
  #   Tynn.development? # => true
  #   Tynn.production?  # => false
  #   Tynn.test?        # => false
  #
  # @example Setting a custom environment
  #   Tynn.set(:environment, :test)
  #
  # @see http://tynn.xyz/environments.html
  #
  module Environment
    # @private
    def self.setup(app, env: ENV["RACK_ENV"])
      app.set(:environment, (env || :development).to_sym)
    end

    module ClassMethods
      # Returns the current environment for the application.
      #
      # @example
      #   Tynn.environment
      #   # => :development
      #
      #   Tynn.set(:environment, :test)
      #
      #   Tynn.environment
      #   # => :test
      #
      # @return [Symbol] current environment
      #
      def environment
        return settings[:environment]
      end

      # Checks if current environment is development.
      #
      # @example
      #   Tynn.set(:environment, :test)
      #   Tynn.development? # => false
      #
      #   Tynn.set(:environment, :development)
      #   Tynn.development? # => true
      #
      # @return [Boolean] Returns `true` if `environment`
      #   is `:development`. Otherwise, `false`.
      #
      def development?
        return environment == :development
      end

      # Checks if current environment is test.
      #
      # @example
      #   Tynn.set(:environment, :development)
      #   Tynn.test? # => false
      #
      #   Tynn.set(:environment, :test)
      #   Tynn.test? # => true
      #
      # @return [Boolean] Returns `true` if `environment`
      #   is `:test`. Otherwise, `false`.
      #
      def test?
        return environment == :test
      end

      # Checks if current environment is production.
      #
      # @example
      #   Tynn.set(:environment, :development)
      #   Tynn.production? # => false
      #
      #   Tynn.set(:environment, :production)
      #   Tynn.production? # => true
      #
      # @return [Boolean] Returns `true` if `environment`
      #   is `:production`. Otherwise, `false`.
      #
      def production?
        return environment == :production
      end
    end
  end
end
