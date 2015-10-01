require_relative "../lib/tynn"

Tynn.define do
  root do
    res.write("hello")
  end
end

run(Tynn)
