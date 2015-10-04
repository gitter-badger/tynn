require "tilt"

module Tynn::Render
  def self.setup(app, options = {}) # :nodoc:
    options = options.dup

    options[:engine]  ||= "erb"
    options[:layout]  ||= "layout"
    options[:views]   ||= File.expand_path("views", Dir.pwd)

    options[:options] ||= {}
    options[:options] = {
      default_encoding: Encoding.default_external,
      outvar: "@_output"
    }.merge!(options[:options])

    app.settings[:render] ||= options
  end

  module ClassMethods
    def layout(layout)
      settings[:render][:layout] = layout
    end
  end

  def render(template, locals = {}, layout = settings[:render][:layout])
    res.headers[Rack::CONTENT_TYPE] ||= Tynn::Response::DEFAULT_CONTENT_TYPE

    res.write(view(template, locals, layout))
  end

  def view(template, locals = {}, layout = settings[:render][:layout])
    return partial(layout, locals.merge(content: partial(template, locals)))
  end

  def partial(template, locals = {})
    return tilt(template_path(template), locals, settings[:render][:options])
  end

  private

  def tilt(file, locals = {}, opts = {})
    return tilt_cache.fetch(file) { Tilt.new(file, 1, opts) }.render(self, locals)
  end

  def tilt_cache
    return Thread.current[:tilt_cache] ||= Tilt::Cache.new
  end

  def template_path(template)
    dir = settings[:render][:views]
    ext = settings[:render][:engine]

    return File.join(dir, "#{ template }.#{ ext }")
  end
end
