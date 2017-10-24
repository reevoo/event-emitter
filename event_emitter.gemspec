# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "event_emitter/version"

Gem::Specification.new do |spec|
  spec.name          = "event_emitter"
  spec.version       = EventEmitter::VERSION
  spec.authors       = ["Reevoo Developers"]
  spec.email         = ["developers@reevoo.com"]
  spec.summary       = "EventEmitter"
  spec.description   = "A Ruby gem for emitting events"
  spec.homepage      = "https://github.com/reevoo/event_emitter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-kclrb", "~> 1.0.1"
  spec.add_dependency "aws-sdk", "~> 3.0.1"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "reevoocop", "~> 0.0.12"

  spec.metadata["allowed_push_host"] = "https://gems.reevoocloud.com"
end
