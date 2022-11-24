module CirroIOV2
  module Resources
    class NotificationLayoutTemplate < Base
      def update(id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{id}", body: params)
        Responses::NotificationLayoutTemplateResponse.new(response.body)
      end

      def delete(id)
        response = client.request_client.request(:delete, "#{resource_root}/#{id}")
        Responses::NotificationLayoutTemplateDeleteResponse.new(response.body)
      end
    end
  end
end
