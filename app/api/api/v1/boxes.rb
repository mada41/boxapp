module API  
  module V1
    class Boxes < Grape::API
      auth :grape_devise_token_auth, resource_class: :user
      helpers GrapeDeviseTokenAuth::AuthHelpers

      version 'v1'
      format :json

      before do
        authenticate_user!
      end

      resource :boxes do
        desc "Return all boxes"
        get '/', root: :boxes do
          current_user.boxes
        end

        desc 'Return a box.'
        params do
          requires :id, type: Integer, desc: 'Box id.'
        end
        route_param :id do
          get do
            Box.find(params[:id])
          end
        end

      end
    end
  end
end 