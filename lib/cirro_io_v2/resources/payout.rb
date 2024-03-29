module CirroIOV2
  module Resources
    class Payout < Base
      def list(params = nil)
        response = client.request_client.request(:get, resource_root, params:)
        Responses::PayoutListResponse.new(response.body)
      end

      def create(params)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::PayoutResponse.new(response.body)
      end

      def delete(id)
        response = client.request_client.request(:delete, "#{resource_root}/#{id}")
        Responses::PayoutDeleteResponse.new(response.body)
      end
    end
  end
end
