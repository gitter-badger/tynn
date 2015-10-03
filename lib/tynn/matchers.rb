# Adds extra matchers to Tynn.
#
#     require "tynn"
#     require "tynn/matchers"
#
#     Tynn.helpers(Tynn::Matchers)
#
module Tynn::Matchers
  # A catch-all matcher.
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
  # :call-seq: default(&block)
  #
  def default
    yield

    halt(res.finish)
  end
end
