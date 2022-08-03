module CirroIOV2
  module Resources
    class User < Base
      def find(id)
        response = client.request_client.request(:get, "#{resource_root}/#{id}")
        CirroIOV2::Responses::UserResponse.build(response.body)
      end

      def notification_preferences(id, params)
        client.request_client.request(:post, "#{resource_root}/#{id}/notification_preferences", body: params)
      end
    end
  end
end
