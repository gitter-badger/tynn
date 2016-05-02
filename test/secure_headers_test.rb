# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/tynn/secure_headers"

class SecureHeadersTest < Tynn::TestCase
  HEADERS = Tynn::SecureHeaders::HEADERS

  test "secure headers" do
    Tynn.plugin(Tynn::SecureHeaders)

    assert_equal HEADERS, Tynn.settings[:default_headers]
  end
end
