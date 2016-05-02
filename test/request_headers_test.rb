# frozen_string_literal: true

require_relative "helper"

class RequestHeadersTest < Tynn::TestCase
  setup do
    env = { "HTTP_HOST" => "127.0.0.1", "CONTENT_TYPE" => "text/plain" }
    request = Tynn::Request.new(env)
    @headers = Tynn::Request::Headers.new(request)
  end

  test "access header" do
    assert_equal "127.0.0.1", @headers["Host"]
  end

  test "key?" do
    assert @headers.key?("Host")
  end

  test "fetch" do
    assert_equal "text/plain", @headers.fetch("content-type")
    assert_equal "text/plain", @headers.fetch("content-type", nil)
    assert_equal "not exists", @headers.fetch("not-exists", "not exists")
    assert_equal "not exists", @headers.fetch("not-exists") { "not exists" }
    assert_raises(KeyError) { @headers.fetch("not-exists") }
  end
end
