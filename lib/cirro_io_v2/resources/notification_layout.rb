module CirroIOV2
  module Resources
    class NotificationLayout < Base
      CREATE_ALLOWED_PARAMS = [:name, :templates].freeze
      CREATE_TEMPLATE_ALLOWED_PARAMS = [:notification_configuration_id, :body].freeze

      def create(params)
        params_allowed?(params, CREATE_ALLOWED_PARAMS)
        response_object(client.request_client.request(:post, resource_root, params))
      end

      def create_template(params)
        params_allowed?(params, CREATE_TEMPLATE_ALLOWED_PARAMS)
        response_object(client.request_client.request(:post, resource_root, params))
      end
    end
  end
end
