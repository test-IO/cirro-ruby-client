module CirroIOV2
  module Resources
    class User < Base
      def create(params = nil)
        response = client.request_client.request(:post, resource_root, body: params)
        CirroIOV2::Responses::UserResponse.new(response.body)
      end

      def find(id)
        response = client.request_client.request(:get, "#{resource_root}/#{id}")
        CirroIOV2::Responses::UserResponse.new(response.body)
      end

      def notification_preference(id)
        response = client.request_client.request(:get, "#{resource_root}/#{id}/notification_preference")
        CirroIOV2::Responses::UserNotificationPreferenceResponse.new(response.body)
      end

      def notification_preferences(id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/notification_preferences", body: params)
        CirroIOV2::Responses::UserNotificationPreferenceResponse.new(response.body)
      end

      def worker(id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/worker", body: params)
        CirroIOV2::Responses::UserResponse.new(response.body)
      end

      def invitation_attempt(id, params)
        response  = client.request_client.request(:post, "#{resource_root}/#{id}/invitation_attempt", body: params)
        CirroIOV2::Responses::UserInvitationAttemptResponse.new(response.body)
      end
    end
  end
end
