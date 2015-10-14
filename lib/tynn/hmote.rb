require "hmote"

class Tynn
  module HMote
    include ::HMote::Helpers

    def self.setup(app, options = {}) # :nodoc:
      options = options.dup

      options[:layout] ||= "layout"
      options[:views]  ||= File.expand_path("views", Dir.pwd)

      app.settings[:hmote] ||= options
    end

    module ClassMethods
      def layout(layout)
        settings[:hmote][:layout] = layout
      end
    end

    def render(template, locals = {}, layout = settings[:hmote][:layout])
      res.headers[Rack::CONTENT_TYPE] ||= Syro::Response::DEFAULT

      res.write(view(template, locals, layout))
    end

    def view(template, locals = {}, layout = settings[:hmote][:layout])
      return partial(layout, locals.merge(content: partial(template, locals)))
    end

    def partial(template, locals = {})
      return hmote(template_path(template), locals.merge(app: self), TOPLEVEL_BINDING)
    end

    private

    def template_path(template)
      return File.join(settings[:hmote][:views], "#{ template }.mote")
    end
  end
end
