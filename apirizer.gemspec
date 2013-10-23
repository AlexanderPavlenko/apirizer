$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'apirizer/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "apirizer"
  s.version     = Apirizer::VERSION
  s.authors     = ["Alexander Pavlenko"]
  s.email       = ["alerticus@gmail.com"]
  s.homepage    = "http://github.com/..."
  s.summary     = "Complex solution for building and securing APIs."
  s.description = "Quartet of Protector, CanCan, Draper and Jbuiled tied together nicely."

  s.files = `git ls-files`.split("\n") - ["Gemfile.lock"]
  s.require_paths = ['lib']

  s.add_dependency 'rails', '~> 4.0.0'
  s.add_dependency 'protector-cancan'
  s.add_dependency 'protector', '~> 0.7'
  s.add_dependency 'cancan'   , '~> 1.6'
  s.add_dependency 'jbuilder' , '~> 1.5'
  s.add_dependency 'draper'   , '~> 1.2'

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
end
