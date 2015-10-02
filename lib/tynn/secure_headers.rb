module Tynn::SecureHeaders
  HEADERS = {
    "X-Content-Type-Options" => "nosniff",
    "X-Frame-Options" => "SAMEORIGIN",
    "X-Permitted-Cross-Domain-Policies" => "none",
    "X-XSS-Protection" => "1; mode=block"
  } # :nodoc:

  def call(env, inbox) # :nodoc:
    result = super(env, inbox)
    result[1].merge!(HEADERS)

    return result
  end
end
