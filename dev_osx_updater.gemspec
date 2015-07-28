require File.expand_path('../lib/dev_osx_updater/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'dev_osx_updater'
  spec.version       = DevOsxUpdater::VERSION
  spec.authors       = ['Callum Barratt']
  spec.email         = ['callum@barratt.me']

  spec.summary       = 'Updates Ruby/Rails development related tools and software.'
  spec.description   = 'Keep your development tools such as homebrew, zsh, rubygems etc up to date with a simple informative script.'
  spec.homepage      = 'https://github.com/cbarratt/mac_system_update'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -- lib/* README.md`.split("\n")
  spec.executables   = ['dev_osx_update']
  spec.require_paths = ['lib']

  spec.add_dependency 'colorize', '0.7.7'

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'pry', '0.10.1'
end
