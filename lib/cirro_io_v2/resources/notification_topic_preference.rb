module CirroIOV2
  module Resources
    class NotificationTopicPreference < Base
      def resource_root
        'notification_topic_preferences'
      end

      def list(params = nil)
        response = client.request_client.request(:get, resource_root, params:)
        Responses::NotificationTopicPreferenceListResponse.new(response.body)
      end
    end
  end
end
