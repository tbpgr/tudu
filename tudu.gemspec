# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tudu/version'

Gem::Specification.new do |spec|
  spec.name          = 'tudu'
  spec.version       = Tudu::VERSION
  spec.authors       = ['tbpgr']
  spec.email         = ['tbpgr@tbpgr.jp']
  spec.description   = %q(Single person's minimum unit of task manager)
  spec.summary       = %q(Single person's minimum unit of task manager)
  spec.homepage      = 'https://github.com/tbpgr/tudu'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'thor', '~> 0.18.1'
  spec.add_runtime_dependency 'highline', "~> 1.6.20"

  spec.add_development_dependency 'rspec', '~> 2.14.1'
  spec.add_development_dependency 'simplecov', '~> 0.8.2'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
