require "tynn"
require "tynn/environment"
require "tynn/protection"
require "tynn/session"

Tynn.plugin(Tynn::Environment)

Tynn.plugin(Tynn::Protection, ssl: Tynn.production?)

Tynn.plugin(Tynn::Session, secret: ENV.fetch("SESSION_SECRET"))

Tynn.define do
  root do
    res.write("be safe")
  end
end
