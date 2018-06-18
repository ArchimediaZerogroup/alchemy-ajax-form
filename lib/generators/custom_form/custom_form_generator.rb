class CustomFormGenerator < Rails::Generators::NamedBase
  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  argument :attributes, type: :array, required: false

  attr_accessor :model_attributes

  def add_admin_cotroller
    template "app/controllers/admin/generic_controller.rb.tt", "app/controllers/admin/#{name.underscore.pluralize}_controller.rb"
  end

  def add_controller
    template "app/controllers/generic_controller.rb.tt", "app/controllers/#{name.underscore.pluralize}_controller.rb"
  end

  def add_resource
    template "app/lib/generic_resource.rb.tt", "app/lib/#{name.singularize.underscore}_resource.rb"
  end

  def add_model

    # inserted_attributes = attributes
    #
    # self.attributes = ["gfgdfgdfg:skdkfjdkf"]
    # parse_attributes!
    #
    # say self.attributes + inserted_attributes
    #
    inserted_attributes = []

    if attributes.empty?
      ask_attribute
    else
      inserted_attributes = attributes
      self.attributes = []
      ask_attribute "Do you want add attributes?"
    end
    parse_attributes!
    self.attributes = inserted_attributes + self.attributes unless inserted_attributes.empty?

    migration_template "db/migrate/generic_migration.rb.tt", "db/migrate/create_#{name.singularize.underscore}.rb"

    template "app/model/generic_form.rb.tt", "app/models/#{name.singularize.underscore}.rb"
    template "app/model/generic_ability.rb.tt", "app/models/#{name.singularize.underscore}_ability.rb"

  end


  def add_element_view

    template "app/views/alchemy/elements/_generic_ajax_form_view.html.erb.tt",
             "app/views/alchemy/elements/_#{name.underscore.singularize}_ajax_form_view.html.erb"

  end

  def add_initializer
    #
    file ="#{Rails.root}/config/initializers/alchemy_ajax_forms.rb"
    if !File.exist? file
      template "config/initializers/alchemy_ajax_forms.rb.tt","config/initializers/alchemy_ajax_forms.rb"
    else
      insert_into_file file, before: "]" do
        <<-code
                                     {
                                       name: 'modules.#{name.underscore.pluralize}', 
                                       controller: '/admin/#{name.underscore.pluralize}',
                                       action: 'index'
                                     },
        code
        end

    end



  end

  def add_mail_template
    template "app/views/alchemy/ajax_forms_mailer/_generic_form.html.erb.tt",
             "app/views/alchemy/ajax_forms_mailer/_#{name.underscore.singularize}.html.erb"
  end

  def add_element_config
    append_to_file "config/alchemy/elements.yml", <<-element
- name: #{name.singularize.underscore}
  hint: false
  contents:
  - name: privacy_page
    type: EssenceText
    settings:
      linkable: true
  - name: recipient_notification
    type: EssenceText
    default: "example@example.it"
    element

  end


  def add_routes

    routes_path = Rails.root + "config/routes.rb"

    if File.exist?(routes_path) and File.readlines(routes_path).grep(/namespace :admin do/).count > 0

      insert_into_file routes_path, :after => "namespace :admin do\n" do
        "resources :#{name.underscore.pluralize}\n"

      end

      route "resources :#{name.underscore.pluralize}\n"


    else
      route <<-route
namespace :admin do
 resources :#{name.underscore.pluralize}
 
end
resources :#{name.underscore.pluralize} , only: [:create]
      route

    end

  end


  private

  def ask_attribute mex = nil
    if mex.nil?
      response = ask "Insert an attribute name (q for exit)"
      if response.downcase != "q"
        self.attributes << response unless response.blank?
        ask_attribute
      end

    else
      response = ask mex, :limited_to => ["y", "n"]
      if response.downcase == "y"
        ask_attribute
      end
    end
  end


  def self.next_migration_number(dir)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end


end
