module CirroIOV2
  module Resources
    class GigInvitation < Base
      ALLOWED_PARAMS = [:user_id, :gig_id, :limit, :before, :after, :status].freeze

      def list(params = nil)
        params_allowed?(params, ALLOWED_PARAMS) if params
        response = client.request_client.request(:get, resource_root, params: params)
        Responses::GigInvitationListResponse.new(response.body)
      end

      def accept(id)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/accept")
        Responses::GigInvitationResponse.new(response.body)
      end
    end
  end
end
