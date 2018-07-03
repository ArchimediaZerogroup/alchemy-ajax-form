module Alchemy
  class AjaxFormResource < Resource


    def attributes
      attr = super.reject {|c| [:check_privacy,:language_id].include?(c[:name].to_sym)}

      attr += [{
                   name: :language,
                   relation: {
                       name: :language,
                       model_association: Alchemy::Language,
                       attr_method: :name

                   }

               },
               {
                   name: :site,
                   relation: {
                       name: :site,
                       model_association: Alchemy::Site,
                       attr_method: :name

                   }

               }]
    end


    def searchable_attribute_names
      if model.column_names.include? "email"
        [:email]
      else
        []
      end
    end

    def search_field_name
      searchable_attribute_names.join("_or_") + "_cont"
    end


  end
end