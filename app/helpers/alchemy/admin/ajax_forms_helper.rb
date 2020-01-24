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

    end
  end
end