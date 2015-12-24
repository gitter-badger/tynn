require_relative "helper"
require_relative "../lib/tynn/environment"

class EnvironmentTest < Tynn::TestCase
  App = Class.new(Tynn)

  setup do
    App.plugin Tynn::Environment, env: :development
  end

  test "defaults to development" do
    assert_equal :development, App.environment
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
  end
end
