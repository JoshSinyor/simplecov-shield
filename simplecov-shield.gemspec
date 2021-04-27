# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'simplecov-shield'
  spec.version       = '0.1.1'
  spec.authors       = ['Andrew Terris', 'Lesley Dennison']
  spec.email         = ['atterris@gmail.com']
  spec.description   = 'Shield generator for SimpleCov'
  spec.summary       = 'Shield generator for SimpleCov'
  spec.homepage      = 'https://github.com/aterris/simplecov-shield'
  spec.license       = 'MIT'

  spec.files         = ['lib/simplecov-shield.rb']
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_path  = 'lib'

  spec.add_runtime_dependency 'httparty'
  spec.add_runtime_dependency 'simplecov'

  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rspec'
end
