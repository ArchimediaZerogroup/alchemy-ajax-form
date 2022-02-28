
require "alchemy_cms"
require "js-routes"
require "recaptcha/rails"
require "mjml-rails"
require "recaptcha"
require "alchemy/ajax/form/engine"

module Alchemy
  module Ajax
    module Form
      # Your code goes here...
      mattr_accessor :enable_mjml, :recaptcha_badge
      @@enable_mjml = true
      @@recaptcha_badge = 'inline'


    end
  end
end
