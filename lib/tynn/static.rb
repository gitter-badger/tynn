class Tynn
  # Public: Adds support for static files (javascript files, images,
  # stylesheets, etc).
  #
  # Examples
  #
  #   require "tynn"
  #   require "tynn/static"
  #
  #   Tynn.plugin(Tynn::Static, ["/js", "/css"])
  #
  # By default, serves all requests beginning with the given paths from
  # the folder +public+ in the current directory (e.g. +public/js/*+,
  # +public/css/*+). You can change the default by passing the +:root+
  # option.
  #
  # Examples
  #
  #   Tynn.plugin(Tynn::Static, ["/js", "/css"], root: "assets")
  #
  # Under the hood, it uses the +Rack::Static+ middleware. Thus,
  # supports all the options available by the middleware. Check
  # {Rack::Static}[http://www.rubydoc.info/gems/rack/Rack/Static]
  # for more information.
  #
  # Examples
  #
  #   Tynn.plugin(Tynn::Static, ["/js", "/css"], index: "index.html")
  #
  module Static
    def self.setup(app, urls, opts = {}) # :nodoc:
      options = opts.dup

      options[:urls] ||= urls
      options[:root] ||= File.expand_path("public", Dir.pwd)

      app.use(Rack::Static, options)
    end
  end
end
