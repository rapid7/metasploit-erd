# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metasploit/erd/version'

Gem::Specification.new do |spec|
  spec.name          = 'metasploit-erd'
  spec.version       = Metasploit::ERD::VERSION
  spec.authors       = ['Luke Imhoff']
  spec.email         = ['luke_imhoff@rapid7.com']
  spec.summary       = 'Extensions to rails-erd to find clusters of models to generate subdomains specific to each model'
  spec.description   = 'Traces the belongs_to associations on ActiveRecord::Base descendants to find the minimum ' \
                       'cluster in which all foreign keys are fulfilled in the Entity-Relationship Diagram.'
  spec.homepage      = 'https://github.com/rapid7/metasploit-erd'
  spec.license       = 'BSD-3-clause'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.3'
  spec.add_development_dependency 'rspec', '~> 2.14'

  # restrict from rails 4.0 to be compatible with rest of metasploit ecosystem.
  # @todo Update to work with rails 4 (MSP-9836)
  rails_version_constraints = ['>= 3.2', '< 4.0.0']

  spec.add_runtime_dependency 'activerecord', *rails_version_constraints
  spec.add_runtime_dependency 'activesupport', *rails_version_constraints
  spec.add_runtime_dependency 'rails-erd', '~> 1.1'
end
