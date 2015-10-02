module Tynn::Static
  def self.setup(app, urls, options = {}) # :nodoc:
    options = options.dup

    options[:urls] ||= urls
    options[:root] ||= File.expand_path("public", Dir.pwd)

    app.use(Rack::Static, options)
  end
end
