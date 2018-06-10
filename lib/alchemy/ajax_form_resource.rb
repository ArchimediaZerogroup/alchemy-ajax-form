module Alchemy
  class AjaxFormResource < Resource


    def attributes
      attr = (super + model.stored_attributes[:serialized_data].collect {|col|
        {
            name: col,
            type: :string
        }
      }).reject {|c| [:serialized_data, :check_privacy].include?(c[:name].to_sym)}

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
      [:email]
    end

    def search_field_name
      searchable_attribute_names.join("_or_") + "_cont"
    end


  end
end