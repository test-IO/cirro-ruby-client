module CirroIOV2
  module Resources
    class NotificationTopic < Base
      ALLOWED_PARAMS = [:name, :notification_layout_id, :preferences, :templates].freeze
      ALLOWED_LIST_PARAMS = [:notification_layout_id, :limit, :before, :after].freeze

      def resource_root
        'notification_topics'
      end

      def list(params = nil)
        params_allowed?(params, ALLOWED_LIST_PARAMS) if params
        response = client.request_client.request(:get, resource_root, params: params)
        Responses::NotificationTopicListResponse.new(response.body)
      end

      def create(params)
        params_allowed?(params, ALLOWED_PARAMS)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::NotificationTopicResponse.new(response.body)
      end
    end
  end
end
