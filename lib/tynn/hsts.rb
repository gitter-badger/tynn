class Tynn
  module HSTS
    def self.setup(app, options = {}) # :nodoc:
      header = sprintf("max-age=%i", options.fetch(:expires, 15_552_000))
      header << "; includeSubdomains" if options.fetch(:subdomains, true)
      header << "; preload" if options[:preload]

      app.settings[:default_headers]["Strict-Transport-Security"] = header
    end
  end
end
