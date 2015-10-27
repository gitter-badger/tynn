require "tynn"

require_relative "users"

Tynn.define do
  on("users") do
    run(Users)
  end
end
