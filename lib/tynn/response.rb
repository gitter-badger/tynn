class Tynn
  # Public: It provides convenience methods to construct a Rack response.
  #
  # Examples
  #
  #   res = Tynn::Response.new
  #
  #   res.status = 200
  #   res["Content-Type"] = "text/html"
  #   res.write("foo")
  #
  #   res.finish
  #   # => [200, { "Content-Type" => "text/html", "Content-Length" => 3 }, ["foo"]]
  #
  class Response < Syro::Response
    # Public: Initializes a new response object.
    #
    # headers - A Hash of initial headers. Defaults to <tt>{}</tt>.
    #
    # Examples
    #
    #   Tynn::Response.new.headers
    #   # => {}
    #
    #   Tynn::Response.new("Content-Type" => "text/plain").headers
    #   # => { "Content-Type" => "text/plain" }
    #
    # Signature
    #
    #   new(headers = {})
    #
    # Inherited by Syro::Response.

    # Public: Returns the response header corresponding to +key+.
    #
    # key - A String HTTP header field name.
    #
    # Examples
    #
    #     res["Content-Type"]   # => "text/html"
    #     res["Content-Length"] # => "42"
    #
    # Signature
    #
    #   [](key)
    #
    # Inherited by Syro::Response.

    # Public: Sets the given +value+ with the header corresponding to +key+.
    #
    # key   - A String HTTP header field name.
    # value - A String HTTP header field value.
    #
    # Examples
    #
    #     res["Content-Type"] = "application/json"
    #     res["Content-Type"] # => "application/json"
    #
    # Signature
    #
    #   []=(key, value)
    #
    # Inherited by Syro::Response.

    # Public: Returns the body of the response.
    #
    # Examples
    #
    #   res.body
    #   # => []
    #
    #   res.write("there is")
    #   res.write("no try")
    #
    #   res.body
    #   # => ["there is", "no try"]
    #
    # Signature
    #
    #   body()
    #
    # Inherited by Syro::Response.

    # Public: Returns an Array with three elements: the status, headers
    # and body. If the status is not set, the status is set to +404+ if
    # empty body, otherwise the status is set to +200+ and updates the
    # +Content-Type+ header to +text/html+.
    #
    # Examples
    #
    #   res.status = 200
    #   res.finish
    #   # => [200, {}, []]
    #
    #   res.status = nil
    #   res.finish
    #   # => [404, {}, []]
    #
    #   res.status = nil
    #   res.write("yo")
    #   res.finish
    #   # => [200, { "Content-Type" => "text/html", "Content-Length" => 2 }, ["yo"]]
    #
    # Signature
    #
    #   finish()
    #
    # Inherited by Syro::Response.

    # Public: Returns a Hash with the response headers.
    #
    # Examples
    #
    #   res.headers
    #   # => { "Content-Type" => "text/html", "Content-Length" => "42" }
    #
    # Signature
    #
    #   headers()
    #
    # Inherited by Syro::Response.

    # Public: Sets the +Location+ header to +url+ and updates the status
    # to +status+.
    #
    # url    - A String URL (relative or absolute) to redirect to.
    # status - An Integer status code. Defaults to +302+.
    #
    # Examples
    #
    #   res.redirect("/path")
    #
    #   res["Location"] # => "/path"
    #   res.status      # => 302
    #
    #   res.redirect("http://tynn.xyz", 303)
    #
    #   res["Location"] # => "http://tynn.xyz"
    #   res.status      # => 303
    #
    # Signature
    #
    #   redirect(url, status = 302)
    #
    # Inherited by Syro::Response.

    # Public: Returns the status of the response.
    #
    # Examples
    #
    #     res.status # => 200
    #
    # Signature
    #
    #   status()
    #
    # Inherited by Syro::Response.

    # Public: Sets the status of the response.
    #
    # status - An Integer HTTP status code.
    #
    # Examples
    #
    #   res.status = 200
    #
    # Signature
    #
    #   status=(status)
    #
    # Inherited by Syro::Response.

    # Public: Appends +str+ to the response body and updates the
    # +Content-Length+ header.
    #
    # str - Any object that responds to +to_s+.
    #
    # Examples
    #
    #   res.body # => []
    #
    #   res.write("foo")
    #   res.write("bar")
    #
    #   res.body
    #   # => ["foo", "bar"]
    #
    #   res["Content-Length"]
    #   # => 6
    #
    # Signature
    #
    #   write(str)
    #
    # Inherited by Syro::Response.

    # Public: Sets a cookie into the response.
    #
    # name - A String name for the new cookie.
    # value - A String value or hash of options.
    #
    # Examples
    #
    #   res.set_cookie("foo", "bar")
    #   res["Set-Cookie"] # => "foo=bar"
    #
    #   res.set_cookie("foo2", "bar2")
    #   res["Set-Cookie"] # => "foo=bar\nfoo2=bar2"
    #
    #   res.set_cookie("bar", {
    #     domain: ".example.com",
    #     path: "/",
    #     # max_age: 0,
    #     # expires: Time.now + 10_000,
    #     secure: true,
    #     httponly: true,
    #     value: "bar"
    #   })
    #
    #   res["Set-Cookie"].split("\n").last
    #   # => "bar=bar; domain=.example.com; path=/; secure; HttpOnly
    #
    # NOTE. This method doesn't sign and/or encrypt the value of the cookie.
    #
    # Signature
    #
    #   set_cookie(name, value)
    #
    # Inherited by Syro::Response

    # Public: Deletes given cookie.
    #
    # name - A String name of a cookie.
    #
    # Examples
    #
    #   res.set_cookie("foo", "bar")
    #   res["Set-Cookie"]
    #   # => "foo=bar"
    #
    #   res.delete_cookie("foo")
    #   res["Set-Cookie"]
    #   # => "foo=; max-age=0; expires=Thu, 01 Jan 1970 00:00:00 -0000"
    #
    # Signature
    #
    #   delete_cookie(name)
    #
    # Inherited by Syro::Response
  end
end
