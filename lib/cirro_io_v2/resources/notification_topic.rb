module CirroIOV2
  module Resources
    class NotificationTopic < Base
      ALLOWED_PARAMS = [:name, :notification_layout_id, :preferences, :templates].freeze

      def resource_root
        'notification_topics'
      end

      def create(params)
        params_allowed?(params, ALLOWED_PARAMS)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::NotificationTopicResponse.new(response.body)
      end
    end
  end
end
