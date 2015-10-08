module Tynn::CSRF
  def csrf
    @csrf ||= Tynn::CSRF::Helper.new(self)
  end

  class Helper
    CSRF_HEADER = "HTTP_X_CSRF_TOKEN".freeze # :nodoc:

    def initialize(app)
      @app = app
      @req = app.req
    end

    def token
      return session[:csrf_token] ||= SecureRandom.base64(32)
    end

    def reset!
      session.delete(:csrf_token)
    end

    def safe?
      return @req.get? || @req.head? || verify_token
    end

    def unsafe?
      return !safe?
    end

    def form_tag
      return %Q(<input type="hidden" name="csrf_token" value="#{ token }">)
    end

    def meta_tag
      return %Q(<meta name="csrf_token" content="#{ token }">)
    end

    private

    def verify_token
      return @req[:csrf_token] == token || @req.env[CSRF_HEADER] == token
    end

    def session
      return @app.session
    end
  end
end
