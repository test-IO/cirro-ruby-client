module CirroIOV2
  module Resources
    class GigInvitation < Base
      def list(user_id: nil, gig_id: nil, limit: 10, before: nil, after: nil, status: nil)
        params = { user_id: user_id, gig_id: gig_id, limit: limit, before: before, after: after, status: status }
        response = client.request_client.request(:get, resource_root, params: params)
        OpenStruct.new(response.body)
      end

      def accept(id)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/accept")
        OpenStruct.new(response.body)
      end
    end
  end
end
