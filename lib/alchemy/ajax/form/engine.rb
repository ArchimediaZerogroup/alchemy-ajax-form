module Alchemy
  module Ajax
    module Form
      class Engine < ::Rails::Engine

        isolate_namespace Alchemy

        config.autoload_paths << config.root.join('lib')

        initializer "alchemy_ajax_form.assets.precompile" do |app|
          app.config.assets.precompile << 'alchemy_ajax_form_manifest.js'
        end


        # initializer "alchemy_ajax_form.assets.precompile" do |app|
        #   app.config.assets.precompile << %w(alchemy/ajax_form.png)
        # end
      end
    end
  end
end
