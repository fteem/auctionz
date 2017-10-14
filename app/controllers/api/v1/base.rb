module API
  module V1
    class Base < Grape::API
      mount API::V1::Lots::Bids

      if Rails.env.development? || Rails.env.staging?
        add_swagger_documentation(
          api_version: 'v1',
          hide_documentation_path: true,
          mount_path: '/api/doc/v1',
          hide_format: true,
          info: {
            title: 'Aucionz API'
          }
        )
      end
    end
  end
end
