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
 end
end
