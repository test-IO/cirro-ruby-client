module CirroIOV2
  module Resources
    class NotificationLayout < Base
      CREATE_ALLOWED_PARAMS = [:name, :templates].freeze
      UPDATE_ALLOWED_PARAMS = [:name].freeze
      CREATE_TEMPLATE_ALLOWED_PARAMS = [:notification_configuration_id, :body].freeze

      def list(params = nil)
        response = client.request_client.request(:get, resource_root, params: params)
        Responses::NotificationLayoutListResponse.new(response.body)
      end

      def create(params)
        params_allowed?(params, CREATE_ALLOWED_PARAMS)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::NotificationLayoutResponse.new(response.body)
      end

      def update(id, params)
        params_allowed?(params, UPDATE_ALLOWED_PARAMS)
        response = client.request_client.request(:post, "#{resource_root}/#{id}", body: params)
        Responses::NotificationLayoutResponse.new(response.body)
      end

      def create_template(id, params)
        params_allowed?(params, CREATE_TEMPLATE_ALLOWED_PARAMS)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/notification_layout_templates", body: params)
        Responses::NotificationLayoutTemplateResponse.new(response.body)
      end
    end
  end
end
