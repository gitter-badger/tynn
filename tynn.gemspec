require_relative "lib/tynn/version"

Gem::Specification.new do |s|
  s.name        = "tynn"
  s.version     = Tynn::VERSION
  s.summary     = "Thin library to create web applications"
  s.description = s.summary
  s.author      = "Francesco Rodríguez"
  s.email       = "frodsan@protonmail.ch"
  s.homepage    = "https://github.com/frodsan/tynn"
  s.license     = "MIT"

  s.files      = Dir["LICENSE", "README.md", "lib/**/*.rb"]
  s.test_files = Dir["test/**/*.rb"]

  s.add_dependency "syro", "~> 2.0"

  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency "cutest", "~> 1.2"
  s.add_development_dependency "erubis", "~> 2.7"
  s.add_development_dependency "hmote", "~> 1.4"
  s.add_development_dependency "mote", "~> 1.1"
  s.add_development_dependency "rdoc", "~> 4.2"
  s.add_development_dependency "redcarpet", "~> 3.3"
  s.add_development_dependency "tilt", "~> 2.0"
end
