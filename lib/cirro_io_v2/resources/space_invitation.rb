module CirroIOV2
  module Resources
    class SpaceInvitation < Base
      def create(params)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::SpaceInvitationResponse.new(response.body)
      end

      def expire(id)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/expire")
        Responses::SpaceInvitationResponse.new(response.body)
      end
    end
  end
end
