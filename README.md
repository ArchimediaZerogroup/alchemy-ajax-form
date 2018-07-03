# Alchemy::Ajax::Form
Short description and motivation.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'alchemy-ajax-form', github: "ArchimediaZerogroup/alchemy-ajax-form"
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install alchemy-ajax-form
```

install mjml 4.1.0 with npm globally (with sudo if necessary)
```bash
$ npm install mjml@4.1.0 -g
```


## Usage
Launch the generator with this command:
```bash
$ bin/rails generate custom_form name_of_form param:type
```
example:
```bash
$ bin/rails generate custom_form contact_form email:string firstname:string lastname:string message:text
```

Ansawer to the questions step by step

Configure element in layoutpage

Restart Server

###How use without generator
If you don't wont use the generator you have to follow these steps:

Let's assume we want to create the form "ContactForm"

####Create Admin Controller

Create Admin::ContactFormsController (/app/controllers/admin/contact_forms_controller.rb)

```ruby
class Admin::ContactFormsController < Alchemy::Admin::AjaxFormsController

end
```

####Create Controller
Create ContactFormsController (/app/controllers/admin/contact_forms_controller.rb)

```ruby
class ContactFormsController < Alchemy::AjaxFormsController

end
```

####Create Resource
Create ContactFormResource (app/lib/contact_form_resource.rb)

```ruby
class ContactFormResource < Alchemy::AjaxFormResource

end
```

####Create Model
Create ContactForm (app/models/contact_form.rb)

```ruby
class ContactForm < Alchemy::AjaxForm

  validates :check_privacy, inclusion: [true, '1']


  def notify_subject
    I18n.translate(:contact_form_notify, scope: [:ajax_form_mailer, :subjects])
  end

  def notify_user_subject
    I18n.translate(:contact_form_user_notify, scope: [:ajax_form_mailer, :subjects])
  end


end
```

####Create Ability
Create ContactFormAbility (app/models/contact_form_ability.rb)

```ruby
class ContactFormAbility
  include CanCan::Ability

  def initialize(user)
    if user.present? && user.is_admin?
      can :manage, ContactForm
      cannot :create, ContactForm
      cannot :update, ContactForm
      can :manage, :admin_contact_forms
      cannot :create, :admin_contact_forms
      cannot :update, :admin_contact_forms
    end
  end

end
```

####Create Migration
Create CreateContactForm (db/migrate/%Y%m%d%H%M%Screate_contact_form.rb)

```ruby
class CreateContactForm < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_forms do |t|
    
    # insert all form fields
    
      t.boolean :check_privacy
      t.references :language, index: true
      t.timestamps
    end
  end
end
```

####Create Element Configuration
Insert into file "config/alchemy/elements.yml"

```yaml
- name: contact_form
  hint: false
  contents:
  - name: privacy_page
    type: EssenceText
    settings:
      linkable: true
  - name: recipient_notification
    type: EssenceText
    default: "example@example.it"
  - name: send_only
    type: EssenceBoolean
  - name: send_staff
    type: EssenceBoolean
  - name: send_user
    type: EssenceBoolean\n

```

####Create Element View
Create contact form view "app/views/alchemy/elements/_contact_form_view.html.erb"

```erbruby
<% cache(element) do %>
  <%= element_view_for(element) do |el| -%>


    <%
      privacy_link = element.content_by_name(:privacy_page).essence.link
      privacy_title = element.content_by_name(:privacy_page).essence.body
      @contact_form = ContactForm.new
      @contact_form.alcm_element = element.id
    %>


    <div class="messages"></div>


    <%= form_for(@contact_form, url: main_app.contact_forms_path, method: :post, remote: true, multipart: true,html:{class: "ajax_forms"}) do |f| %>
      <%= f.hidden_field :alcm_element %>
      <div class="row">
      #list of attributes
      </div>

    <% if !privacy_title.blank? %>
       <div class="privacy">
         <div class="single_privacy">
           <%= f.check_box :check_privacy %>
           <%= link_to privacy_link do %>
             <label><%= privacy_title %></label>
           <% end %>
         </div>
       </div>
     <% else %>
       <%= f.check_box :check_privacy %>
     <% end %>


      <div class="submit">
      <%= f.submit t(:submit) %>
      </div>

    <% end %>



  <%- end -%>
<%- end -%>
```

####Create or add entry to initializer

Create or edit alchemy_ahax_forms initializer ( config/initializers/alchemy_ajax_forms.rb)

```ruby
Alchemy::Modules.register_module({
                                   name: 'alchemy_ajax_forms',
                                   order: 1,
                                   navigation: {
                                     name: 'modules.contact_forms',
                                     controller: '/admin/contact_forms',
                                     action: 'index',
                                     image: 'alchemy/ajax_form.png',
                                     sub_navigation: [
                                     {
                                       name: 'modules.contact_forms',
                                       controller: '/admin/contact_forms',
                                       action: 'index'
                                     },
                                     ]
                                   }
                                 })

Alchemy.register_ability(ContactFormAbility)

module Alchemy

EMAIL_NOTIFY= "example@example.it"
EMAIL_NOTIFY_FROM = "no-reply@example.it"

end
```

If you add multiple form add only:
```ruby
{
  name: 'modules.contact_forms',
  controller: '/admin/contact_forms',
  action: 'index'
}
```
and ability
```ruby
Alchemy.register_ability(ContactFormAbility)
```

####Create Mail Template

Create email template ()app/views/alchemy/ajax_forms_mailer/_contact_form.mjml)
Create email template for user notification ()app/views/alchemy/ajax_forms_mailer/_contact_form_user.mjml)

```ruby
<mj-column>
  <mj-text align="left" color="#55575d" font-family="Arial, sans-serif" font-size="13px" line-height="22px" padding-bottom="0px" padding-top="5px" padding="10px 25px">
    <p style="line-height: 16px; text-align: center; margin: 10px 0;font-size:12px;color:#000;font-family:'Times New Roman',Helvetica,Arial,sans-serif">
       <span><b>attribute name:</b></span>
       <span><%= rec.attribute_name %></span>
    </p>
  </mj-text>
</mj-column>
```

####Add Routes
Add right routes

```ruby
namespace :admin do
 resources :contact_forms
 
end
resources :contact_forms , only: [:create]
```

####Require assets
Add to app/assets/javascripts/application.js

```ruby
//= require jquery3
//= require ajax_forms
```

###Run Migration
Run migration with rake task

```ruby
bin/rake db:migrate
```

Configure element in layoutpage

Restart Server
             
##Translations



## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
