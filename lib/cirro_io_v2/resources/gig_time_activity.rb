module CirroIOV2
  module Resources
    class GigTimeActivity < Base
      def list(params = nil)
        response = client.request_client.request(:get, resource_root, params: params)
        Responses::GigTimeActivityListResponse.new(response.body)
      end

      def create(params)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::GigTimeActivityResponse.new(response.body)
      end
    end
  end
end
