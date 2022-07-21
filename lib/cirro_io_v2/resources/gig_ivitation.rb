module CirroIOV2
  module Resources
    class GigInvitation < Base
      def list(user_id: nil, gig_id: nil, before: nil, after: nil, status: nil, limit: 10)
        # TODO: Is it ok? as rubocop says:  Avoid parameter lists longer than 5 parameters.
        # [6/5] (https://rubystyle.guide#too-many-params)
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
