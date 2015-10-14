require "erubis"
require_relative "render"

class Tynn
  module Erubis
    def self.setup(app, options = {}) # :nodoc:
      options = options.dup

      options[:options] ||= {}
      options[:options] = {
        escape_html: true
      }.merge!(options[:options])

      app.helpers(Tynn::Render, options)
    end
  end
end
