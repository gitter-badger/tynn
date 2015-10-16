class Tynn
  # It provides convenience methods to construct a Rack response.
  #
  # ```
  # res = Tynn::Response.new
  # res.status = 200
  # res["Content-Type"] = "text/html"
  # res.write("foo")
  # ```
  #
  # [Tynn::Response#finish][finish] returns a response as per
  # [Rack's specification][rack-spec].
  #
  # ```
  # res.finish
  # # => [200, { "Content-Type" => "text/html", "Content-Length" => 3 }, ["foo"]]
  # ```
  #
  # [finish]: #method-i-finish
  # [rack-spec]: http://www.rubydoc.info/github/rack/rack/master/file/SPEC
  #
  class Response < Syro::Response
    ##
    # :method: new
    # :call-seq: new(headers = {})
    #
    # Initializes a new response object with the given `headers`.
    #
    # ```
    # Tynn::Response.new.headers
    # # => {}
    #
    # Tynn::Response.new("Content-Type" => "text/plain").headers
    # # => { "Content-Type" => "text/plain" }
    # ```

    ##
    # :method: []
    #
    # Returns the response header corresponding to `key`.
    #
    #     res["Content-Type"]   # => "text/html"
    #     res["Content-Length"] # => "42"

    ##
    # :method: []=
    # :call-seq: []=(value)
    #
    # Sets the given `value` with the header corresponding to `key`.
    #
    #     res["Content-Type"] = "application/json"
    #     res["Content-Type"] # => "application/json"

    ##
    # :method: body
    #
    # Returns the body of the response.
    #
    #     res.body
    #     # => []
    #
    #     res.write("there is")
    #     res.write("no try")
    #
    #     res.body
    #     # => ["there is", "no try"]

    ##
    # :method: finish
    #
    # Returns an array with three elements: the status, headers and body.
    # If the status is not set, the status is set to 404 if empty body,
    # otherwise the status is set to 200 and updates the `Content-Type`
    # header to `text/html`.
    #
    #     res.status = 200
    #     res.finish
    #     # => [200, {}, []]
    #
    #     res.status = nil
    #     res.finish
    #     # => [404, {}, []]
    #
    #     res.status = nil
    #     res.write("yo")
    #     res.finish
    #     # => [200, { "Content-Type" => "text/html", "Content-Length" => 2 }, ["yo"]]

    ##
    # :method: headers
    #
    # Returns a hash with the response headers.
    #
    #     res.headers
    #     # => { "Content-Type" => "text/html", "Content-Length" => "42" }

    ##
    # :method: redirect
    # :call-seq: redirect(path, 302)
    #
    # Sets the `Location` header to `path` and updates the status to
    # `status`. By default, `status` is `302`.
    #
    #     res.redirect("/path")
    #
    #     res["Location"] # => "/path"
    #     res.status      # => 302
    #
    #     res.redirect("http://tynn.ru", 303)
    #
    #     res["Location"] # => "http://tynn.ru"
    #     res.status      # => 303

    ##
    # :method: status
    #
    # Returns the status of the response.
    #
    #     res.status # => 200
    #

    ##
    # :method: status=
    # :call-seq: status=(status)
    #
    # Sets the status of the response.
    #
    #     res.status = 200
    #

    ##
    # :method: write
    # :call-seq: write(str)
    #
    # Appends `str` to `body` and updates the `Content-Length` header.
    #
    #     res.body # => []
    #
    #     res.write("foo")
    #     res.write("bar")
    #
    #     res.body
    #     # => ["foo", "bar"]
    #
    #     res["Content-Length"]
    #     # => 6

    ##
    # :method: set_cookie
    # :call-seq: set_cookie(key, value)
    #
    # Sets a cookie into the response.
    #
    #     res.set_cookie("foo", "bar")
    #     res["Set-Cookie"] # => "foo=bar"
    #
    #     res.set_cookie("foo2", "bar2")
    #     res["Set-Cookie"] # => "foo=bar\nfoo2=bar2"
    #
    #     res.set_cookie("bar", {
    #       domain: ".example.com",
    #       path: "/",
    #       # max_age: 0,
    #       # expires: Time.now + 10_000,
    #       secure: true,
    #       httponly: true,
    #       value: "bar"
    #     })
    #
    #     res["Set-Cookie"].split("\n").last
    #     # => "bar=bar; domain=.example.com; path=/; secure; HttpOnly
    #
    # **NOTE:** This method doesn't sign and/or encrypt the value of the cookie.

    ##
    # :method: delete_cookie
    # :call-seq: delete_cookie(key, value = {})
    #
    # Deletes cookie.
    #
    #     res.set_cookie("foo", "bar")
    #     res["Set-Cookie"]
    #     # => "foo=; max-age=0; expires=Thu, 01 Jan 1970 00:00:00 -0000"
  end
end
