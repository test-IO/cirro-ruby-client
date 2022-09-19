module CirroIOV2
  module Resources
    class Payout < Base
      def create(params)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::PayoutResponse.new(response.body)
      end
    end
  end
end
