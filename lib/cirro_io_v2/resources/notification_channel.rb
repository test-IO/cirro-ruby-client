module CirroIOV2
  module Resources
    class NotificationChannel < Base
      ALLOWED_PARAMS = [:name, :notification_layout_id, :preferences, :templates].freeze

      def create(params)
        params_allowed?(params, ALLOWED_PARAMS)
        response_object(client.request_client.request(:post, resource_root, params))
      end
    end
  end
end
