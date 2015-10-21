require "seteable"
require "syro"
require_relative "tynn/request"
require_relative "tynn/response"
require_relative "tynn/version"

class Tynn
  include Seteable
  include Syro::Deck::API

  # Sets the application handler.
  #
  # ```
  # class Users < Tynn
  # end
  #
  # Users.define do
  #   on(:id) do |id|
  #     get do
  #       res.write("GET /users")
  #     end
  #
  #     post do
  #       res.write("POST /users")
  #     end
  #   end
  # end
  # ```
  #
  def self.define(&block)
    build_app(Syro.new(self, &block))
  end

  # Adds given Rack `middleware` to the stack.
  #
  # ```
  # require "rack/common_logger"
  # require "rack/show_exceptions"
  #
  # Tynn.use(Rack::CommonLogger)
  # Tynn.use(Rack::ShowExceptions)
  # ```
  #
  def self.use(middleware, *args, &block)
    __middleware << proc { |app| middleware.new(app, *args, &block) }
  end

  def self.call(env) # :nodoc:
    return @app.call(env)
  end

  def self.build_app(syro) # :nodoc:
    if __middleware.empty?
      @app = syro
    else
      @app = __middleware.reverse.inject(syro) { |a, m| m.call(a) }
    end
  end

  def self.__middleware # :nodoc:
    return @middleware ||= []
  end

  def self.reset! # :nodoc:
    @app = nil
    @middleware = []
  end

  # Extends Tynn functionality with the given `helper` module.
  #
  # ```
  # module AppName
  #   def self.setup(app, name)
  #     app.set(:app_name, name)
  #   end
  #
  #   def app_name
  #     return self.class.app_name
  #   end
  #
  #   module ClassMethods
  #     def app_name
  #       return settings[:app_name]
  #     end
  #   end
  # end
  #
  # Tynn.helpers(AppName, "MyApplication")
  #
  # Tynn.app_name # => "MyApplication"
  #
  # Tynn.set(:app_name, "MyGreatestApp")
  # Tynn.app_name # => "MyGreatestApp"
  #
  # Tynn.define do
  #   root do
  #     res.write(app_name)
  #   end
  # end
  # ```
  #
  # Check the [helpers][examples] that come with tynn for more examples.
  #
  # [examples]: https://github.com/frodsan/tynn/tree/master/lib/tynn
  #
  def self.helpers(helper, *args, &block)
    self.include(helper)

    if defined?(helper::ClassMethods)
      self.extend(helper::ClassMethods)
    end

    if helper.respond_to?(:setup)
      helper.setup(self, *args, &block)
    end
  end

  def self.set(key, value)
    settings[key] = value
  end

  def request_class # :nodoc:
    return Tynn::Request
  end

  def response_class # :nodoc:
    return Tynn::Response
  end

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
