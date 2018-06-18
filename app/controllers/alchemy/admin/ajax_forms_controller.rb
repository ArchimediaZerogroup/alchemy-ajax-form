module Alchemy
  module Admin
    class AjaxFormsController < ResourcesController

      def resource_handler
        @_resource_handler ||= "::#{controller_name.classify}Resource".constantize.new(controller_path, alchemy_module)
      end

      def index
        @query = resource_handler.model.ransack(search_filter_params[:q])
        items = @query.result
        items = items.order(created_at: :desc)

        if contains_relations?
          items = items.includes(*resource_relations_names)
        end

        if search_filter_params[:tagged_with].present?
          items = items.tagged_with(search_filter_params[:tagged_with])
        end

        if search_filter_params[:filter].present?
          items = items.public_send(sanitized_filter_params)
        end

        respond_to do |format|
          format.html {
            items = items.page(params[:page] || 1).per(per_page_value_for_screen_size)
            instance_variable_set("@#{resource_handler.resources_name}", items)
          }
          format.csv {
            instance_variable_set("@#{resource_handler.resources_name}", items)
          }
        end
      end

      protected

      def common_search_filter_includes
        [
            # contrary to Rails' documentation passing an empty hash to permit all keys does not work
            {options: options_from_params.keys},
            {q: [resource_handler.search_field_name, :s]},
            :tagged_with,
            :filter,
            :page
        ].freeze
      end


    end
  end
end
