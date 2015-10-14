class Tynn
  # Adds support for static files (javascript files, images, stylesheets, etc).
  #
  # ```
  # require "tynn"
  # require "tynn/static"
  #
  # Tynn.helpers(Tynn::Static, ["/js", "/css"])
  # ```
  #
  # By default, serve all requests beginning with the given paths from the folder
  # `public` in the current directory (e.g. `public/js/*`, `public/css/*`). You
  # can change the default by passing the `:root` option.
  #
  # ```
  # Tynn.helpers(Tynn::Static, ["/js", "/css"], root: "assets")
  # ```
  #
  # Under the hood, it uses the [Rack::Static][rack-static] middleware.
  # Thus, supports all the options available for this middleware.
  #
  # ```
  # Tynn.helpers(Tynn::Static, ["/js", "/css"], index: "index.html")
  # ```
  #
  # [rack-static]: http://www.rubydoc.info/gems/rack/Rack/Static
  #
  module Static
    def self.setup(app, urls, options = {}) # :nodoc:
      options = options.dup

      options[:urls] ||= urls
      options[:root] ||= File.expand_path("public", Dir.pwd)

      app.use(Rack::Static, options)
    end
  end
end
