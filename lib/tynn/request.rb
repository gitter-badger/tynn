# frozen_string_literal: true

class Tynn
  # It provides convenience methods for pulling out information from a request.
  #
  # @example
  #   env = {
  #     "REQUEST_METHOD" => "GET",
  #     "QUERY_STRING"   => "email=me@tynn.xyz"
  #   }
  #
  #   req = Tynn::Request.new(env)
  #
  #   req.get?  # => true
  #   req.post? # => false
  #
  #   req.params  # => { "email" => "me@tynn.xyz" }
  #   req[:email] # => "me@tynn.xyz"
  #
  # @see http://www.rubydoc.info/gems/rack/Rack/Request
  #
  class Request < Rack::Request
    class Headers
      CGI_VARIABLES = Set.new(%w(
        AUTH_TYPE
        CONTENT_LENGTH
        CONTENT_TYPE
        GATEWAY_INTERFACE
        HTTPS
        PATH_INFO
        PATH_TRANSLATED
        QUERY_STRING
        REMOTE_ADDR
        REMOTE_HOST
        REMOTE_IDENT
        REMOTE_USER
        REQUEST_METHOD
        SCRIPT_NAME
        SERVER_NAME
        SERVER_PORT
        SERVER_PROTOCOL
        SERVER_SOFTWARE
      )).freeze

      def initialize(req)
        @req = req
      end

      def [](key)
        @req.env[transform_key(key)]
      end

      def fetch(key, *args, &block)
        @req.env.fetch(transform_key(key), *args, &block)
      end

      def key?(key)
        @req.env.key?(transform_key(key))
      end

      private

      def transform_key(key)
        key = key.upcase.tr("-", "_")
        key = "HTTP_" + key unless CGI_VARIABLES.include?(key)
        key
      end
    end

    def headers
      @headers ||= Headers.new(self)
    end
  end
end
