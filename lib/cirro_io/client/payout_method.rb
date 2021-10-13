module CirroIO
  module Client
    class PayoutMethod < Base
      extend CirroIO::Client::BulkActionHelper

      has_one :worker

      # rubocop:disable Metrics/AbcSize
      def self.create(type, payout_data, worker_id)
        payload = { data: { type: 'payout-methods', attributes: {}, relationships: {} } }

        attributes = payload[:data][:attributes]
        relationships = payload[:data][:relationships]

        attributes[:payout_method_type] = type
        attributes[:payout_data] = payout_data

        relationships[:worker] = {}
        relationships[:worker][:data] = {}
        relationships[:worker][:data][:type] = 'workers'
        relationships[:worker][:data][:id] = worker_id

        response = custom_post('payout-methods', format_to_dashed_keys(payload), { 'Content-Type' => 'application/vnd.api+json' })

        parser.parse(self, response).first
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
