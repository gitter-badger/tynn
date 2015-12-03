class Tynn
  # Public: Adds helper methods to get and check the current environment.
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/environment"
  #
  #   Tynn.plugin(Tynn::Environment)
  #
  #   Tynn.environment  # => :development
  #
  #   Tynn.development? # => true
  #   Tynn.production?  # => false
  #   Tynn.test?        # => false
  #
  # By default, the environment is based on <tt>ENV["RACK_ENV"]</tt>.
  #
  # Examples
  #
  #   Tynn.plugin(Tynn::Environment, env: ENV["RACK_ENV"])
  #
  module Environment
    def self.setup(app, env: ENV["RACK_ENV"]) # :nodoc:
      app.set(:environment, (env || :development).to_sym)
    end

    module ClassMethods
      # Public: Returns current environment.
      #
      # Examples
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
        return settings[:environment]
      end

      # Public: Returns +true+ if the current environment is +:development+.
      # Otherwise returns +false+.
      #
      # Examples
      #
      #   Tynn.set(:environment, :test)
      #   Tynn.development? # => false
      #
      #   Tynn.set(:environment, :development)
      #   Tynn.development? # => true
      #
      def development?
        return environment == :development
      end

      # Public: Returns +true+ if the current environment is +:test+.
      # Otherwise returns +false+.
      #
      # Examples
      #
      #   Tynn.set(:environment, :development)
      #   Tynn.test? # => false
      #
      #   Tynn.set(:environment, :test)
      #   Tynn.test? # => true
      #
      def test?
        return environment == :test
      end

      # Public: Returns +true+ if the current environment is +:production+.
      # Otherwise returns +false+.
      #
      # Examples
      #
      #   Tynn.set(:environment, :development)
      #   Tynn.production? # => false
      #
      #   Tynn.set(:environment, :production)
      #   Tynn.production? # => true
      #
      def production?
        return environment == :production
      end
    end
  end
end
