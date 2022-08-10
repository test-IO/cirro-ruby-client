module CirroIOV2
  module Resources
    class NotificationLayoutTemplate < Base
      UPDATE_ALLOWED_PARAMS = [:notification_configuration_id, :body].freeze

      def update(params)
        params_allowed?(params, UPDATE_ALLOWED_PARAMS)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::NotificationLayoutTemplateResponse.new(response.body)
      end

      def delete(id)
        response = client.request_client.request(:delete, "#{resource_root}/#{id}")
        Responses::NotificationLayoutTemplateDeleteResponse.new(response.body)
      end
    end
  end
end
