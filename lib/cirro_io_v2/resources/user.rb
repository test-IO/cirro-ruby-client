module CirroIOV2
  module Resources
    class User < Base
      def find(id)
        client.request_client.request(:get, "#{resource_root}/#{id}")
      end

      def notification_preferences(id, params)
        client.request_client.request(:post, "#{resource_root}/#{id}/notification_preferences", params)
      end
    end
  end
end
