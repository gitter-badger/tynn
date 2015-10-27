class Tynn
  # The following methods are inherited by Syro:

  # Public: Immediately stops the request and returns +response+
  # as per Rack's specification.
  #
  # response - An Array of three elements: status, headers and body.
  #
  # Examples
  #
  #   halt([200, { "Content-Type" => "text/html" }, ["hello"]])
  #   halt([res.status, res.headers, res.body])
  #   halt(res.finish)
  #
  # Signature
  #
  #   halt(response)
  #
  # Inherited by Syro::Response.

  # Public: Returns the incoming request object. This object is an
  # instance of Tynn::Request.
  #
  # Examples
  #
  #   req.post?      # => true
  #   req.params     # => { "username" => "bob", "password" => "secret" }
  #   req[:username] # => "bob"
  #
  # Signature
  #
  #   req()
  #
  # Inherited by Syro::Response.

  # Public: Returns the current response object. This object is an instance
  # of Tynn::Response.
  #
  # Examples
  #
  #   res.status = 200
  #   res["Content-Type"] = "text/html"
  #   res.write("<h1>Welcome back!</h1>")
  #
  # Signature
  #
  #   res()
  #
  # Inherited by Syro::Response.
end
