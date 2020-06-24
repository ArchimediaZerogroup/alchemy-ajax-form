module Alchemy
  module Admin
    module AjaxFormsHelper

      def alchemy_body_class
        [
            "ajax_forms",
            controller_name,
            action_name,
            content_for(:main_menu_style),
            content_for(:alchemy_body_class)
        ].compact
      end

      def search_panel(options = {}, &block)
        submit_button = options.fetch(:enable_submit, true)
        klass = options.delete(:class) || []
        content_tag(:div, class: "search_panel #{klass.join(" ")}", ** options) do
          if @query
            simple_form_for(@query, url: polymorphic_path([:admin, @query.klass]), method: :get) do |f|
              sb = ActiveSupport::SafeBuffer.new

              sb << content_tag(:div, class: "search_fields_group") do
                search_fields = ActiveSupport::SafeBuffer.new
                search_fields << f.input(resource_handler.search_field_name,
                              label: false,
                              input_html: {
                                  class: 'search_input_field',
                                  placeholder: Alchemy.t(:search)
                              }
                )

                search_fields << capture do
                  block.call(f)
                end
                search_fields
              end
              if submit_button
                sb << content_tag(:div, class: "action_buttons") do
                  f.submit(::I18n.t('alchemy_ajax_form.submit_search'))
                end
              end
              sb
            end
          end
        end
      end

    end
  end
end