require_relative "lib/tynn/version"

Gem::Specification.new do |s|
  s.name        = "tynn"
  s.version     = Tynn::VERSION
  s.summary     = "Thin library to create web applications"
  s.description = s.summary
  s.authors     = ["Francesco Rodríguez"]
  s.email       = ["frodsan@protonmail.ch"]
  s.homepage    = "https://github.com/frodsan/tynn"
  s.license     = "MIT"

  s.files      = Dir["LICENSE", "README.md", "lib/**/*.rb"]
  s.test_files = Dir["test/**/*.rb"]

  s.add_dependency "rack", "~> 1.6"
  s.add_dependency "seteable", "~> 1.1"
  s.add_dependency "syro", "~> 1.1"

  s.add_development_dependency "cutest", "~> 1.2"
  s.add_development_dependency "erubis", "~> 2.7"
  s.add_development_dependency "hmote", "~> 1.4"
  s.add_development_dependency "rack-test", "~> 0.6"
  s.add_development_dependency "tilt", "~> 2.0"
end
