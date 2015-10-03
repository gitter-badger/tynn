require_relative "../lib/tynn/environment"

test "default" do
  Tynn.helpers(Tynn::Environment)

  assert_equal(:development, Tynn.environment)
end

test "helpers" do
  Tynn.helpers(Tynn::Environment)

  assert Tynn.development?
  assert !Tynn.test?
  assert !Tynn.production?
end

test "use RACK_ENV by default" do
  ENV["RACK_ENV"] = "production"

  Tynn.helpers(Tynn::Environment)

  assert_equal(:production, Tynn.environment)

  ENV.delete("RACK_ENV")
end

test "use custom value" do
  Tynn.helpers(Tynn::Environment, env: "development")

  assert_equal(:development, Tynn.environment)
end
