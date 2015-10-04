class Tynn
  class Response
    LOCATION = "Location".freeze
    DEFAULT_CONTENT_TYPE = "text/html".freeze

    def initialize(headers = {})
      @status  = nil
      @headers = headers
      @body    = []
      @length  = 0
    end

    def status=(status)
      @status = status
    end

    def status
      return @status
    end

    def headers
      return @headers
    end

    def body
      return @body
    end

    def [](key)
      return @headers[key]
    end

    def []=(key, value)
      @headers[key] = value
    end

    def write(str)
      s = str.to_s

      @length += s.bytesize
      @headers[Rack::CONTENT_LENGTH] = @length.to_s

      @body << s
    end

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
