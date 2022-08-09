module CirroIOV2
  module Resources
    class NotificationLocale < Base
      ALLOWED_PARAMS = [:locale].freeze

      def create(params)
        params_allowed?(params, ALLOWED_PARAMS)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::NotificationLocaleResponse.new(response.body)
      end

      def list
        response = client.request_client.request(:get, resource_root)
        Responses::NotificationLocaleListResponse.new(response.body)
      end
    end
  end
end
