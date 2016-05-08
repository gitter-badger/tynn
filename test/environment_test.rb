# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/tynn/environment"

class EnvironmentTest < Tynn::TestCase
  setup do
    @app = Class.new(Tynn)
  end

  test "defaults to development if RACK_ENV is nil" do
    begin
      env, ENV["RACK_ENV"] = ENV.to_h, nil

      @app.plugin(Tynn::Environment)

      assert_equal :development, @app.environment
    ensure
      ENV.replace(env)
    end
  end

  test "defaults to RACK_ENV if present" do
    begin
      env, ENV["RACK_ENV"] = ENV.to_h, "test"

      @app.plugin(Tynn::Environment)

      assert_equal :test, @app.environment
    ensure
      ENV.replace(env)
    end
  end

  test "set environment" do
    @app.plugin(Tynn::Environment)

    @app.environment = "test"

    assert_equal :test, @app.environment
  end

  test "adds predicate methods" do
    @app.plugin(Tynn::Environment, env: :development)

    assert_equal true, @app.development?
    assert_equal false, @app.production?
    assert_equal false, @app.test?
    assert_equal false, @app.staging?
  end

  test "configure" do
    @app.plugin(Tynn::Environment)

    @app.environment = :test

    @app.configure(:test) do
      @app.set(:test, true)
    end

    @app.configure(:development, :test) do |app|
      app.set(:production, false)
    end

    @app.configure(:production) do
      raise "This should not be executed"
    end

    assert_equal true, @app.settings[:test]
    assert_equal false, @app.settings[:production]
  end
end
