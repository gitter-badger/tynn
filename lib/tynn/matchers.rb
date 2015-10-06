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

  # Match if the given `param` is present.
  #
  #     Tynn.define do
  #       param(:user) do |params|
  #         user = User.create(params)
  #       end
  #
  #       default do
  #         res.write("missing param")
  #       end
  #     end
  #
  def param(key)
    if (v = req[key]) && !v.empty?
      yield(v)

      halt(res.finish)
    end
  end
end
