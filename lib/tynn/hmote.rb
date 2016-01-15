require "hmote"

class Tynn
  module HMote
    # @private
    def self.setup(app, options = {})
      app.set(:layout, options.fetch(:layout, "layout"))
      app.set(:views, options.fetch(:views, File.expand_path("views", Dir.pwd)))
    end

    module InstanceMethods
      include ::HMote::Helpers

      def render(template, locals = {}, layout = settings[:layout])
        res.headers[Rack::CONTENT_TYPE] ||= Tynn::Response::DEFAULT

        res.write(view(template, locals, layout))
      end

      def view(template, locals = {}, layout = settings[:layout])
        partial(layout, locals.merge(content: partial(template, locals)))
      end

      def partial(template, locals = {})
        hmote(template_path(template), locals.merge(app: self), TOPLEVEL_BINDING)
      end

      private

      def template_path(template)
        File.join(settings[:views], "#{ template }.mote")
      end
    end
  end
end
