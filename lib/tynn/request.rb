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
  end
end
