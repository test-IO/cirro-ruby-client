module CirroIOV2
  module Resources
    class NotificationConfiguration < Base
      def list(params = nil)
        response = client.request_client.request(:get, resource_root, params:)
        Responses::NotificationConfigurationListResponse.new(response.body)
      end
    end
  end
end
