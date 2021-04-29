$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "alchemy/ajax/form/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "alchemy-ajax-form"
  s.version     = Alchemy::Ajax::Form::VERSION
  s.authors     = ["Alessandro Baccanelli"]
  s.email       = ["alessandro.baccanelli@archimedianet.it"]
  s.homepage    = ""
  s.summary     = "Structure to implement the forms using ajax and management in the backend"
  s.description = "Structure to implement the forms using ajax and management in the backend"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">=5.0","<7.0"
  s.add_dependency "js-routes", "~>1.0"
  s.add_dependency "sass-rails", "~> 6.0"
  s.add_dependency 'alchemy_cms', '~> 5.0'
  s.add_dependency 'recaptcha','~> 4.7'
  s.add_dependency 'mjml-rails','~> 4.1'
  s.add_dependency 'jquery-rails','~>4.0'


  #s.add_development_dependency "sqlite3"
end
