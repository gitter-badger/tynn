# Adds support for HTTP Strict-Transport Security (HSTS).
#
#   require "tynn"
#   require "tynn/hsts"
#
#   Tynn.helpers(Tynn::HSTS)
#
module Tynn::HSTS
  HSTS_HEADER = "Strict-Transport-Security".freeze # :nodoc:
  HSTS_EXPIRE = 15_552_000 # 180 days # :nodoc:

  def self.setup(app, options = {}) # :nodoc:
    max_age = options.fetch(:max_age, HSTS_EXPIRE)
    subdomains = options.fetch(:subdomains, true)
    preload = options.fetch(:preload, false)

    header = sprintf("max-age=%i", max_age)
    header << "; includeSubdomains" if subdomains
    header << "; preload" if preload

    app.settings[:hsts] = header
  end

  def call(env, inbox) # :nodoc:
    result = super(env, inbox)
    result[1][HSTS_HEADER] = settings[:hsts]

    return result
  end
end
