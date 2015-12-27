class Tynn
  # It provides convenience methods to construct a Rack response.
  #
  # @example
  #   res = Tynn::Response.new
  #
  #   res.status = 200
  #   res["Content-Type"] = "text/html"
  #   res.write("foo")
  #
  #   res.finish
  #   # => [200, { "Content-Type" => "text/html", "Content-Length" => 3 }, ["foo"]]
  #
  # @see http://www.rubydoc.info/gems/syro/Syro/Response
  #
  class Response < Syro::Response
  end
end
