module CirroIOV2
  module Resources
    class NotificationBroadcast < Base
      ALLOWED_PARAMS = [:payload, :recipients, :notification_topic_id].freeze

      def create(params)
        params_allowed?(params, ALLOWED_PARAMS)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::NotificationBroadcastResponse.new(response.body)
      end
    end
  end
end
