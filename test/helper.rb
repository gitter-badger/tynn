$VERBOSE = true

require "bundler/setup"
require "cutest"
require_relative "../lib/tynn"
require_relative "../lib/tynn/test"

prepare do
  Tynn.reset!
end
