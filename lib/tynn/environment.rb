# frozen_string_literal: true

class Tynn
  # Adds helper methods to get and check the current environment.
  # By default, the environment is based on +ENV["RACK_ENV"]+.
  #
  #   require "tynn"
  #   require "tynn/environment"
  #
  #   Tynn.plugin(Tynn::Environment)
  #
  #   # Accessing the current environment
  #   Tynn.environment  # => :development
  #
  #   # Check the current environment
  #   Tynn.development? # => true
  #   Tynn.production?  # => false
  #   Tynn.test?        # => false
  #   Tynn.staging?     # => false
  #
  #   # Setting a custom environment
  #   Tynn.set(:environment, :test)
  #
  module Environment
    def self.setup(app, env: ENV["RACK_ENV"]) # :nodoc:
      app.set(:environment, (env || :development).to_sym)
    end

    module ClassMethods
      # Yields if current environment matches one of the given environments.
      #
      #   class MyApp < Tynn
      #     configure(:development, :staging) do
      #       use(BetterErrors::Middleware)
      #     end
      #
      #     configure(:production) do
      #       plugin(Tynn::SSL)
      #     end
      #   end
      #
      def configure(*envs)
        yield if envs.include?(environment)
      end

      # Returns the current environment for the application.
      #
      #   Tynn.environment
      #   # => :development
      #
      #   Tynn.set(:environment, :test)
      #
      #   Tynn.environment
      #   # => :test
      #
      def environment
        settings[:environment]
      end

      # Checks if current environment is development.
      # Returns +true+ if +environment+ is +:development+.
      # Otherwise, +false+.
      #
      #   Tynn.set(:environment, :test)
      #   Tynn.development? # => false
      #
      #   Tynn.set(:environment, :development)
      #   Tynn.development? # => true
      #
      def development?
        environment == :development
      end

      # Checks if current environment is test.
      # Returns +true+ if +environment+ is +:test+.
      # Otherwise, +false+.
      #
      #   Tynn.set(:environment, :development)
      #   Tynn.test? # => false
      #
      #   Tynn.set(:environment, :test)
      #   Tynn.test? # => true
      #
      def test?
        environment == :test
      end

      # Checks if current environment is production.
      # Returns +true+ if +environment+ is +:production+.
      # Otherwise, +false+.
      #
      #   Tynn.set(:environment, :development)
      #   Tynn.production? # => false
      #
      #   Tynn.set(:environment, :production)
      #   Tynn.production? # => true
      #
      def production?
        environment == :production
      end

      # Checks if current environment is staging.
      # Returns +true+ if +environment+ is +:staging+.
      # Otherwise, +false+.
      #
      #   Tynn.set(:environment, :test)
      #   Tynn.staging? # => false
      #
      #   Tynn.set(:environment, :staging)
      #   Tynn.staging? # => true
      #
      def staging?
        environment == :staging
      end
    end
  end
end
