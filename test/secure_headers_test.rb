require_relative "../lib/tynn/secure_headers"

test "secure headers" do
  Tynn.helpers(Tynn::SecureHeaders)

  Tynn.define do
    root do
      res.write("safe")
    end
  end

  app = Tynn::Test.new
  app.get("/")

  secure_headers = {
    "X-Content-Type-Options" => "nosniff",
    "X-Frame-Options" => "SAMEORIGIN",
    "X-Permitted-Cross-Domain-Policies" => "none",
    "X-XSS-Protection" => "1; mode=block"
  }

  headers = app.res.headers

  secure_headers.each do |header, value|
    assert_equal(value, headers[header])
  end
end
