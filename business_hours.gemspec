# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'business_hours/version'

Gem::Specification.new do |spec|
  spec.name          = "business_hours"
  spec.version       = BusinessHours::VERSION
  spec.authors       = ["Ivan Kryak"]
  spec.email         = ["kryak.iv@gmail.com"]
  spec.description   = %q{Allows easily handle opening hours without take care of time zones}
  spec.summary       = %q{Allows easily handle opening hours without take care of time zones}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "timecop"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "tzinfo"
end
