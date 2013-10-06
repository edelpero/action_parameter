# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "action_parameter/version"

Gem::Specification.new do |s|
  s.name          = "action_parameter"
  s.version       = ActionParameter::VERSION.dup
  s.platform      = Gem::Platform::RUBY
  s.summary       = "Single Responsability Principle for Rails Controller's Parameters."
  s.email         = "edelpero@gmail.com"
  s.homepage      = "https://github.com/edelpero/action_parameter"
  s.description   = "Single Responsability Principle for Rails Controller's Parameters."
  s.authors       = ['Ezequiel Delpero']
  s.license       = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency('activesupport', '>= 4.0.0', '< 4.1')
  s.add_dependency('actionpack',    '>= 4.0.0', '< 4.1')
end