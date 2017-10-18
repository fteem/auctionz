module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        rescue_from ActiveRecord::RecordInvalid do |e|
          response = { status: 422, error: e.message }
          error!(response, 422)
        end

        rescue_from Grape::Exceptions::ValidationErrors do |e|
          response = { status: 422, error: 'Unprocessable entity', details: e }
          error!(response, 422)
        end

        rescue_from Grape::Exceptions::MethodNotAllowed do |e|
          response = { status: e.status, error: e.message }
          error!(response, e.status)
        end
      end
    end
  end
end

