# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'visitation/version'

Gem::Specification.new do |spec|
  spec.name          = "visitation"
  spec.version       = Visitation::VERSION
  spec.authors       = ["Gap, Inc."]
  spec.email         = []
  spec.description   = %q{Manipulate array/hash documents}
  spec.summary       = %q{Manipulate array/hash documents}
  spec.homepage      = ""
  spec.license       = "Apache License, Version 2.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
