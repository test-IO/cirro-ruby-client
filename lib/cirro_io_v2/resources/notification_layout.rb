module CirroIOV2
  module Resources
    class NotificationLayout < Base
      def list(params = nil)
        response = client.request_client.request(:get, resource_root, params: params)
        Responses::NotificationLayoutListResponse.new(response.body)
      end

      def create(params)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::NotificationLayoutResponse.new(response.body)
      end

      def update(id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{id}", body: params)
        Responses::NotificationLayoutResponse.new(response.body)
      end

      def create_template(id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/notification_layout_templates", body: params)
        Responses::NotificationLayoutTemplateResponse.new(response.body)
      end
    end
  end
end
