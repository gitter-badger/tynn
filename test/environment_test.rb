require_relative "helper"
require_relative "../lib/tynn/environment"

class EnvironmentTest < Tynn::TestCase
  App = Class.new(Tynn)
  App.plugin(Tynn::Environment)

  setup do
    App.reset!
    App.set(:environment, :development)
  end

  test "defaults to development" do
    NewApp = Class.new(Tynn)
    NewApp.plugin(Tynn::Environment)

    assert_equal :development, NewApp.environment
  end

  test "defaults to RACK_ENV if present" do
    begin
      env, ENV["RACK_ENV"] = ENV.to_h, "test"

      App.plugin(Tynn::Environment)

      assert_equal :test, App.environment
    ensure
      ENV.replace(env)
    end
  end

  test "environment setting" do
    App.set(:environment, :test)

    assert_equal :test, App.environment
  end

  test "adds predicate methods" do
    assert_equal true, App.development?
    assert_equal false, App.production?
    assert_equal false, App.test?
    assert_equal false, App.staging?
  end

  test "configure" do
    class App
      set(:environment, :test)

      configure(:test) do
        set(:test, true)
      end

      configure(:development, :test) do
        set(:production, false)
      end

      configure(:production) do
        raise "This should not be executed"
      end
    end

    assert_equal true, App.settings[:test]
    assert_equal false, App.settings[:production]
  end
end
