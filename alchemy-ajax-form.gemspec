$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "alchemy/ajax/form/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "alchemy-ajax-form"
  s.version     = Alchemy::Ajax::Form::VERSION
  s.authors     = ["Alessandro Baccanelli"]
  s.email       = ["alessandro.baccanelli@archimedianet.it"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Alchemy::Ajax::Form."
  s.description = "TODO: Description of Alchemy::Ajax::Form."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0"
  s.add_dependency "js-routes"
  s.add_dependency 'alchemy_cms', '~> 4.0'
  s.add_dependency 'alchemy-devise', '~> 4.0'

  #s.add_development_dependency "sqlite3"
end
