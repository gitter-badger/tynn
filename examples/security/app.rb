require "tynn"
require "tynn/environment"
require "tynn/protection"
require "tynn/session"

Tynn.helpers(Tynn::Environment)

Tynn.helpers(Tynn::Protection, ssl: Tynn.production?)

Tynn.helpers(Tynn::Session, secret: ENV.fetch("SESSION_SECRET"))

Tynn.define do
  root do
    res.write("be safe")
  end
end
