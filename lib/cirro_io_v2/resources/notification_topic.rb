module CirroIOV2
  module Resources
    class NotificationTopic < Base
      def resource_root
        'notification_topics'
      end

      def find(id)
        response = client.request_client.request(:get, "#{resource_root}/#{id}")
        Responses::NotificationTopicResponse.new(response.body)
      end

      def update(id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{id}", body: params)
        Responses::NotificationTopicResponse.new(response.body)
      end

      def list(params = nil)
        response = client.request_client.request(:get, resource_root, params: params)
        Responses::NotificationTopicListResponse.new(response.body)
      end

      def create(params)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::NotificationTopicResponse.new(response.body)
      end

      def delete(id)
        response = client.request_client.request(:delete, "#{resource_root}/#{id}")
        Responses::NotificationTopicDeleteResponse.new(response.body)
      end
    end
  end
end
