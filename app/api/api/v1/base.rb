module API  
  module V1
    class Base < Grape::API
      mount API::V1::Boxes

      add_swagger_documentation(
        api_version: "v1",
        base_path: "/api",
        format: :json,
        hide_documentation_path: true,
        hide_format: true
      )

    end
  end
end