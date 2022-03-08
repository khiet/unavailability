
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "unavailability/version"

Gem::Specification.new do |spec|
  spec.name          = "unavailability"
  spec.version       = Unavailability::VERSION
  spec.authors       = ["Khiet Le"]
  spec.email         = ["khiet.le@ehochef.com"]

  spec.summary       = %q{Manage availabilities of a Model}
  spec.homepage      = "https://github.com/khiet/unavailability"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', '~> 6.0'

  spec.add_development_dependency 'railties', "~> 6.0"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug", "~> 10.0"
  spec.add_development_dependency "sqlite3", "~> 1.4"

  spec.description = <<-EOM
    Unavailability simply adds a capability to manage availabilities.
  EOM
end
