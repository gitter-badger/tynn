require "securerandom"
require_relative "../lib/tynn/csrf"
require_relative "../lib/tynn/session"

setup do
  Tynn.helpers(Tynn::CSRF)
  Tynn.helpers(Tynn::Session, secret: SecureRandom.hex(64))

  Tynn::Test.new
end

test "get should be safe" do |app|
  Tynn.define do
    get do
      res.write(csrf.safe?)
    end
  end

  app.get("/")

  assert_equal "true", app.res.body
end

test "head should be safe" do |app|
  Tynn.define do
    on req.head? do
      res.write(csrf.safe?)
    end
  end

  app.head("/")

  assert_equal "true", app.res.body
end

test "invalid csrf token" do |app|
  Tynn.define do
    post do
      res.write(csrf.unsafe?)
    end
  end

  app.post("/")

  assert_equal "true", app.res.body
end

test "valid csrf token" do |app|
  token = SecureRandom.hex(64)

  Tynn.define do
    post do
      session[:csrf_token] = token

      res.write(csrf.safe?)
    end
  end

  app.post("/", csrf_token: token)

  assert_equal "true", app.res.body
end

test "resets token" do |app|
  token = SecureRandom.hex(64)

  Tynn.define do
    post do
      session[:csrf_token] = token

      if csrf.unsafe?
        csrf.reset!
      end

      res.write(csrf.token)
    end
  end

  app.post("/", csrf_token: "nonsense")

  assert token != app.res.body
end

test "http header" do |app|
  token = SecureRandom.hex(64)

  Tynn.define do
    post do
      session[:csrf_token] = token

      res.write(csrf.safe?)
    end
  end

  app.post("/", {}, "HTTP_X_CSRF_TOKEN" => token)

  assert_equal "true", app.res.body
end
