module CirroIOV2
  module Resources
    class NotificationTemplate < Base
      CREATE_ALLOWED_PARAMS = %i[notification_configuration_id notification_channel_id limit before after].freeze
      UPDATE_ALLOWED_PARAMS = %i[subject body].freeze

      def create(params = nil)
        params_allowed?(params, ALLOWED_PARAMS) if params
        response_object(client.request_client.request(:get, resource_root, params))
      end

      def update(id, params)
        params_allowed?(params, UPDATE_ALLOWED_PARAMS)
        response_object(client.request_client.request(:post, "#{resource_root}/#{id}", params))
      end

      def delete(id)
        response_object(client.request_client.request(:delete, "#{resource_root}/#{id}"))
      end
    end
  end
end
