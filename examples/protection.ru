require_relative "../lib/tynn"
require_relative "../lib/tynn/environment"
require_relative "../lib/tynn/protection"
require_relative "../lib/tynn/session"

Tynn.helpers(Tynn::Environment)

Tynn.helpers(Tynn::Protection, ssl: Tynn.production?)

Tynn.helpers(Tynn::Session, secret: SecureRandom.hex(64))

Tynn.define do
  root do
    res.write("use protection")
  end
end

run(Tynn)
