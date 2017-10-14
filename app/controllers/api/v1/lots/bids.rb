module API
  module V1
    module Lots
      class Bids < Grape::API
        resource :lots do
          route_param :lot_id do
            params do
              requires :lot_id, type: Integer, desc: 'Lot ID'
            end
            resource :bids do
              params do
                requires :amount, type: Integer, desc: 'Amount'
              end
              desc 'Create a lot bid', headers: { "Idempotency-Key" => { "type" => "string" }}
              post do
                lot = Lot.find(params[:lot_id])
                lot.bids.create!(amount: params[:amount])

                body false
              end
            end
          end
        end
      end
    end
  end
end
