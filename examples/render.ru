require "erb"
require_relative "../lib/tynn"
require_relative "../lib/tynn/render"

Tynn.helpers(Tynn::Render, views: File.expand_path("views", __dir__))

Tynn.define do
  root do
    render("home", title: "Thanks for using Tynn!")
  end
end

run(Tynn)
