module CirroIOV2
  module Resources
    class GigResult < Base
      def create(params)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::GigResultResponse.new(response.body)
      end
    end
  end
end
