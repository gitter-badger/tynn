# Adds a catch-all matcher.
#
#     require "tynn"
#     require "tynn/default_matcher"
#
#     Tynn.helpers(Tynn::DefaultMatcher)
#
#     Tynn.define do
#       authenticated? do
#         # ...
#       end
#
#       default do # on true
#         # ...
#       end
#     end
#
module Tynn::DefaultMatcher
  def default # :nodoc:
    yield

    halt(res.finish)
  end
end
