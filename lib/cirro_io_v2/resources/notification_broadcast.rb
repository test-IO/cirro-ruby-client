module CirroIOV2
  module Resources
    class NotificationBroadcast < Base
      def create(params)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::NotificationBroadcastResponse.new(response.body)
      end
    end
  end
end
