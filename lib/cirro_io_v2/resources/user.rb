module CirroIOV2
  module Resources
    class User < Base
      def find(id)
        response = client.request_client.request(:get, "#{resource_root}/#{id}")
        CirroIOV2::Responses::UserResponse.new(response.body)
      end

      def notification_preferences(id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/notification_preferences", body: params)
        CirroIOV2::Responses::UserNotificationPreferenceResponse.new(response.body)
      end

      def worker(id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/worker", body: params)
        CirroIOV2::Responses::UserResponse.new(response.body)
      end
    end
  end
end
