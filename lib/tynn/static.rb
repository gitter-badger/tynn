class Tynn
  # Adds support for static files (javascript files, images,
  # stylesheets, etc).
  #
  # By default, serves all requests beginning with the given paths from
  # the folder `public/` in the current directory (e.g. `public/js/*`,
  # `public/css/*`). You can change the default by passing the `:root`
  # option.
  #
  # Under the hood, it uses the `Rack::Static` middleware. Thus,
  # supports all the options available by the middleware.
  #
  # @example
  #   require "tynn"
  #   require "tynn/static"
  #
  #   Tynn.plugin(Tynn::Static, ["/js", "/css"])
  #   Tynn.plugin(Tynn::Static, ["/js", "/css"], root: "assets")
  #   Tynn.plugin(Tynn::Static, ["/js", "/css"], index: "index.html")
  #
  # @see http://tynn.xyz/static-files.html
  # @see http://www.rubydoc.info/gems/rack/Rack/Static
  #
  module Static
    # @private
    def self.setup(app, urls, opts = {})
      options = opts.dup

      options[:urls] ||= urls
      options[:root] ||= File.expand_path("public", Dir.pwd)

      app.use(Rack::Static, options)
    end
  end
end
