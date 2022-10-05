module CirroIOV2
  module Resources
    class NotificationTemplate < Base
      def list(params = nil)
        response = client.request_client.request(:get, resource_root, params: params)
        Responses::NotificationTemplateListResponse.new(response.body)
      end

      def update(id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{id}", body: params)
        Responses::NotificationTemplateResponse.new(response.body)
      end

      def delete(id)
        response = client.request_client.request(:delete, "#{resource_root}/#{id}")
        Responses::NotificationTemplateDeleteResponse.new(response.body)
      end
    end
  end
end
