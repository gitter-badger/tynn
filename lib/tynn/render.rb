require "tilt"

class Tynn
  module Render
    def self.setup(app, options = {}) # :nodoc:
      app.settings.update(
        layout: options.fetch(:layout, "layout"),
        views: options.fetch(:views, File.expand_path("views", Dir.pwd)),
        engine: options.fetch(:engine, "erb"),
        engine_opts: {
          default_encoding: Encoding.default_external,
          outvar: "@_output"
        }.merge!(options.fetch(:options, {}))
      )
    end

    def render(template, locals = {}, layout = settings[:layout])
      res.headers[Rack::CONTENT_TYPE] ||= Syro::Response::DEFAULT

      res.write(view(template, locals, layout))
    end

    def view(template, locals = {}, layout = settings[:layout])
      return partial(layout, locals.merge(content: partial(template, locals)))
    end

    def partial(template, locals = {})
      return tilt(template_path(template), locals, settings[:engine_opts])
    end

    private

    def tilt(file, locals = {}, opts = {})
      return tilt_cache.fetch(file) { Tilt.new(file, 1, opts) }.render(self, locals)
    end

    def tilt_cache
      return Thread.current[:tilt_cache] ||= Tilt::Cache.new
    end

    def template_path(template)
      dir = settings[:views]
      ext = settings[:engine]

      return File.join(dir, "#{ template }.#{ ext }")
    end
  end
end
