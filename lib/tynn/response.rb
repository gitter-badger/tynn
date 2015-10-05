class Tynn
  class Response
    LOCATION = "Location".freeze # :nodoc:
    DEFAULT_CONTENT_TYPE = "text/html".freeze # :nodoc:

    def initialize(headers = {}) # :nodoc:
      @status  = nil
      @headers = headers
      @body    = []
      @length  = 0
    end

    # Sets the status of the response.
    #
    #     res.status = 200
    #
    def status=(status)
      @status = status
    end

    # Returns the status of the response.
    #
    #     res.status # => 200
    #
    def status
      return @status
    end

    # Returns a hash with the response headers.
    #
    #     res.headers
    #     # => { "Content-Type" => "text/html", "Content-Length" => "42" }
    #
    def headers
      return @headers
    end

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
    #
    def body
      return @body
    end

    # Returns the response header corresponding to `key`.
    #
    #     res["Content-Type"]   # => "text/html"
    #     res["Content-Length"] # => "42"
    #
    def [](key)
      return @headers[key]
    end

    # Sets the given `value` with the header corresponding to `key`.
    #
    #     res["Content-Type"] = "application/json"
    #     res["Content-Type"] # => "application/json"
    #
    def []=(key, value)
      @headers[key] = value
    end

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
    #
    def write(str)
      s = str.to_s

      @length += s.bytesize
      @headers[Rack::CONTENT_LENGTH] = @length.to_s

      @body << s
    end

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
    #
    def redirect(path, status = 302)
      @headers[LOCATION] = path
      @status = status
    end

    def finish
      if @status.nil?
        if @body.empty?
          @status = 404
        else
          @headers[Rack::CONTENT_TYPE] ||= DEFAULT_CONTENT_TYPE
          @status = 200
        end
      end

      return [@status, @headers, @body]
    end

    def set_cookie(key, value)
      Rack::Utils.set_cookie_header!(@headers, key, value)
    end

    def delete_cookie(key, value = {})
      Rack::Utils.delete_cookie_header!(@headers, key, value)
    end
  end
end
