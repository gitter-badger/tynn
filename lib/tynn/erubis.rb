require "erubis"
require_relative "render"

module Tynn::Erubis
  def self.setup(app, options = {})
    options = options.dup

    options[:options] ||= {}
    options[:options] = {
      escape_html: true
    }.merge!(options[:options])

    app.helpers(Tynn::Render, options)
  end
end
