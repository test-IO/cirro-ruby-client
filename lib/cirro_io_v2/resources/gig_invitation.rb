module CirroIOV2
  module Resources
    class GigInvitation < Base
      def list(params = nil)
        response = client.request_client.request(:get, resource_root, params: params)
        Responses::GigInvitationListResponse.new(response.body)
      end

      def accept(id)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/accept")
        Responses::GigInvitationResponse.new(response.body)
      end

      def reject(id)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/reject")
        Responses::GigInvitationResponse.new(response.body)
      end

      def expire(id)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/expire")
        Responses::GigInvitationResponse.new(response.body)
      end
    end
  end
end
