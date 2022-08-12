module CirroIOV2
  module Resources
    class NotificationConfiguration < Base
      ALLOWED_PARAMS = [:locale, :limit, :before, :after].freeze

      def list(params = nil)
        params_allowed?(params, ALLOWED_PARAMS) if params
        response = client.request_client.request(:get, resource_root, params: params)
        Responses::NotificationConfigurationListResponse.new(response.body)
      end
    end
  end
end
