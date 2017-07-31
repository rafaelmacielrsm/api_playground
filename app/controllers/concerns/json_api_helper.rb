module JsonApiHelper
 extend ActiveSupport::Concern
 included do
   def json_api_show
     object = controller_name.classify.constantize.find_by_id(params[:id])
     if object
       render json: object, status: :ok
     else
       render json: "null", status: :not_found
     end
   end

   def json_api_create(built_object)
     if built_object.save
       render json: built_object, status: :created
     else
       render( json: {errors: built_object.errors }.to_json,
               status: :unprocessable_entity)
     end
   end
 end
end
