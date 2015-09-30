class Tynn
  module HSTS
    HSTS_HEADER = "Strict-Transport-Security".freeze
    HSTS_EXPIRE = 15_552_000 # 180 days

    def self.setup(app, max_age: HSTS_EXPIRE, subdomains: true, preload: false)
      header = sprintf("max-age=%i", max_age)
      header << "; includeSubdomains" if subdomains
      header << "; preload" if preload

      app.settings[:hsts] = header
    end

    def call(env, inbox)
      result = super(env, inbox)
      result[1][HSTS_HEADER] = settings[:hsts]

      return result
    end
  end
end
