# frozen_string_literal: true

class Tynn
  # Serves static files (javascript files, images, stylesheets, etc).
  #
  # By default, these files are served from the +./public+ folder.
  # A different location can be specified through the +:root+ option.
  #
  # Under the hood, it uses the Rack::Static middleware.
  # Thus, supports all the options available by the middleware.
  #
  #   require "tynn"
  #   require "tynn/static"
  #
  #   Tynn.plugin(Tynn::Static, ["/js", "/css"])
  #   Tynn.plugin(Tynn::Static, ["/js", "/css"], root: "assets")
  #   Tynn.plugin(Tynn::Static, ["/js", "/css"], index: "index.html")
  #
  # For more information on the supported options, please see
  # Rack::Static[http://www.rubydoc.info/gems/rack/Rack/Static].
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
