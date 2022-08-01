module CirroIOV2
  module Resources
    class NotificationLayoutTemplate < Base
      UPDATE_ALLOWED_PARAMS = [:notification_configuration_id, :body].freeze

      def update(params)
        params_allowed?(params, ALLOWED_PARAMS)
        response_object(client.request_client.request(:post, resource_root, params))
      end

      def delete(id)
        response_object(client.request_client.request(:delete, "#{resource_root}/#{id}"))
      end
    end
  end
end
