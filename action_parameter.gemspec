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
  s.description   = "ActionParameter helps you move all your parameter's logic into it's own class. This way you'll keep your controllers dry and they would be easier to test."
  s.authors       = ['Ezequiel Delpero']
  s.license       = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency('minitest', '~> 4.2')

  s.add_dependency('activesupport', '>= 3.0.0')
  s.add_dependency('actionpack',    '>= 3.0.0')
end