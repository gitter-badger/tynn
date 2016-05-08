require_relative "lib/tynn/version"

Gem::Specification.new do |s|
  s.name        = "tynn"
  s.version     = Tynn::VERSION
  s.summary     = "A thin library for web development in Ruby"
  s.description = s.summary
  s.author      = "Francesco Rodriguez"
  s.email       = "hello@frodsan.com"
  s.homepage    = "https://github.com/frodsan/tynn"
  s.license     = "MIT"

  s.files      = Dir["LICENSE", "README.md", "lib/**/*.rb"]
  s.test_files = Dir["test/**/*.rb"]

  s.required_ruby_version = ">= 2.3.0"

  s.add_dependency "rack", "~> 2.0.0.alpha"
  s.add_dependency "syro", "~> 2.1.1"
  s.add_development_dependency "erubis", "~> 2.7"
  s.add_development_dependency "minitest", "~> 5.8"
  s.add_development_dependency "minitest-sugar", "~> 2.1"
  s.add_development_dependency "rake", "~> 11.0"
  s.add_development_dependency "tilt", "~> 2.0"
end
