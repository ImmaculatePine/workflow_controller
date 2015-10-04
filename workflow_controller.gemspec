# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'workflow_controller/version'

Gem::Specification.new do |spec|
  spec.name          = 'workflow_controller'
  spec.version       = WorkflowController::VERSION
  spec.authors       = ['Alexander Borovykh']
  spec.email         = ['immaculate.pine@gmail.com']

  spec.summary       = 'Controller actions for Workflow gem'
  spec.homepage      = 'https://github.com/ImmaculatePine/workflow_controller'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 3.0'
  spec.add_dependency 'workflow'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
