class Tynn
  # The following methods are inherited by Syro:

  ##
  # :method: halt(response)
  #
  # Immediately stops the request and returns `response` as per
  # Rack's specification.
  #
  # ```
  # halt([200, { "Content-Type" => "text/html" }, ["hello"]])
  # halt([res.status, res.headers, res.body])
  # halt(res.finish)
  # ```

  ##
  # :method: req
  #
  # Returns the incoming request object. This object is an instance
  # of Tynn::Request.
  #
  # ```
  # req.post?      # => true
  # req.params     # => { "username" => "bob", "password" => "secret" }
  # req[:username] # => "bob"
  # ```

  ##
  # :method: res
  #
  # Returns the current response object. This object is an instance
  # of Tynn::Response.
  #
  # ```
  # res.status = 200
  # res["Content-Type"] = "text/html"
  # res.write("<h1>Welcome back!</h1>")
  # ```
end
