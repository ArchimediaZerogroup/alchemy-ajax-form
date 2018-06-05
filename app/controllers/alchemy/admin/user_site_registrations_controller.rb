module Alchemy
  module Admin
    class AjaxFormController < ResourcesController

      def resource_handler
        @_resource_handler ||= ::Alchemy::AjaxFormResource.new(controller_path, alchemy_module)
      end

    end
  end
end
