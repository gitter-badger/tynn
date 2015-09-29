require_relative "helper"
require_relative "../lib/tynn/secure_headers"

test "secure headers" do
  Tynn.helpers(Tynn::SecureHeaders)

  Tynn.define do
    root do
      res.write("safe")
    end
  end

  app = Driver.new(Tynn)
  app.get("/")

  headers = app.res.headers

  Tynn::SecureHeaders::HEADERS.each do |header, value|
    assert_equal(value, headers[header])
  end
end
