require_relative "../lib/tynn"
require_relative "../lib/tynn/hmote"

Tynn.helpers(Tynn::HMote, views: File.expand_path("views/hmote", __dir__))

Tynn.define do
  root do
    render("home", title: "Thanks for using Tynn!")
  end
end

run(Tynn)
