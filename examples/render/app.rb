require "erubis"
require "tynn"
require "tynn/render"

Tynn.plugin(Tynn::Render, views: File.expand_path("views", __dir__))

Tynn.define do
  root do
    render("home", title: "Thanks for using Tynn!")
  end
end
