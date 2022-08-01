module CirroIOV2
  module Resources
    class GigInvitation < Base
      LIST_REQUEST_PARAMS = %w[user_id gig_id limit before after status].freeze

      def list(params)
        validate_list_params(params)
        response = client.request_client.request(:get, resource_root, params: params)
        Responses::GigInvitationListResponce.create(response.body)
      end

      def accept(id)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/accept")
        Responses::GigInvitationResponce.create(response.body)
      end

      private

      def validate_list_params(params)
        raise ArgumentError, 'extra param is passed' if LIST_REQUEST_PARAMS.include?(params.keys)
      end
    end
  end
end
