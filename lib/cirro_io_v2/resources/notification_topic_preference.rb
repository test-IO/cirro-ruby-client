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

      def update(id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{id}", body: params)
        Responses::NotificationTopicPreferenceResponse.new(response.body)
      end
    end
  end
end
