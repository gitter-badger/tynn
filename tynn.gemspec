require_relative "lib/tynn/version"

Gem::Specification.new do |s|
  s.name        = "tynn"
  s.version     = Tynn::VERSION
  s.summary     = "Simple library to create Rack applications"
  s.description = s.summary
  s.authors     = ["Francesco Rodríguez"]
  s.email       = ["frodsan@protonmail.ch"]
  s.homepage    = "https://github.com/harmoni/tynn"
  s.license     = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_dependency "rack", "~> 1.6"
  s.add_dependency "syro", "~> 0.0.8"

  s.add_development_dependency "cutest", "1.2.2"
  s.add_development_dependency "hmote", "1.4.0"
  s.add_development_dependency "rack-test", "0.6.3"
  s.add_development_dependency "tilt", "~> 2.0"
end
