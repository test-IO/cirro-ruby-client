module CirroIO
  module Client
    class Bank < Base
      extend CirroIO::Client::BulkActionHelper

      has_one :worker

      def self.create(payout_data, worker_id)
        payload = { data: { type: 'banks', attributes: {}, relationships: {} } }
        payload[:data][:attributes][:payout_data] = payout_data

        payload[:data][:relationships][:data] = {}
        payload[:data][:relationships][:data][:type] = 'workers'
        payload[:data][:relationships][:data][:id] = worker_id

        response = custom_post('banks', format_to_dashed_keys(payload))

        parser.parse(self.class, response).first
      end
    end
  end
end
