require "bundler/setup"
require "tynn"

Tynn.define do
  root do
    res.write("Hello World!")
  end
end
