require "tynn"
require "tynn/hmote"

Tynn.helpers(Tynn::HMote, views: File.expand_path("views", __dir__))

Tynn.define do
  root do
    render("home", title: "Thanks for using Tynn!")
  end
end
