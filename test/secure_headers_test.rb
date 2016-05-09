# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/tynn/secure_headers"

class SecureHeadersTest < Minitest::Test
  HEADERS = Tynn::SecureHeaders::HEADERS

  test "adds secure headers to default headers" do
    app = new_app

    app.plugin(Tynn::SecureHeaders)

    assert_equal HEADERS, app.default_headers
  end
end
