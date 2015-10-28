require_relative "../lib/tynn/environment"

test "use RACK_ENV by default" do
  begin
    old, ENV["RACK_ENV"] = ENV["RACK_ENV"], "production"

    Tynn.plugin(Tynn::Environment)

    assert_equal(:production, Tynn.environment)

    assert !Tynn.development?
    assert !Tynn.test?
    assert Tynn.production?

  ensure
    ENV["RACK_ENV"] = old
  end
end

test "use custom value" do
  Tynn.plugin(Tynn::Environment, env: "development")

  assert_equal(:development, Tynn.environment)
  assert Tynn.development?
  assert !Tynn.test?
  assert !Tynn.production?
end
