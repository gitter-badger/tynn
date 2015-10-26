require "hmote"

class Tynn
  module HMote
    def self.setup(app, options = {}) # :nodoc:
      app.set(:layout, options.fetch(:layout, "layout"))
      app.set(:views, options.fetch(:views, File.expand_path("views", Dir.pwd)))
    end

    module InstanceMethods
      include ::HMote::Helpers

      def render(template, locals = {}, layout = self.class.settings[:layout])
        res.headers[Rack::CONTENT_TYPE] ||= Syro::Response::DEFAULT

        res.write(view(template, locals, layout))
      end

      def view(template, locals = {}, layout = self.class.settings[:layout])
        return partial(layout, locals.merge(content: partial(template, locals)))
      end

      def partial(template, locals = {})
        return hmote(template_path(template), locals.merge(app: self), TOPLEVEL_BINDING)
      end

      private

      def template_path(template)
        return File.join(self.class.settings[:views], "#{ template }.mote")
      end
    end
  end
end
