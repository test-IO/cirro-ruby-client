module CirroIOV2
  module Resources
    class Gig < Base
      def find(id)
        response = client.request_client.request(:get, [resource_root, id].join('/'))
        Responses::GigResponse.new(response.body)
      end

      def create(params)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::GigResponse.new(response.body)
      end

      def update(id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{id}", body: params)
        Responses::GigResponse.new(response.body)
      end

      def archive(id, params = nil)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/archive", body: params)
        Responses::GigResponse.new(response.body)
      end

      def delete(id)
        response = client.request_client.request(:delete, "#{resource_root}/#{id}")
        Responses::GigDeleteResponse.new(response.body)
      end

      def tasks(id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/tasks", body: params)
        Responses::GigTaskResponse.new(response.body)
      end

      def update_task(gig_id, task_id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{gig_id}/tasks/#{task_id}", body: params)
        Responses::GigTaskResponse.new(response.body)
      end

      def invite(id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/invite", body: params)

        return Responses::GigInvitationResponse.new(response.body) if response.body['object'] == 'gig_invitation'
        return Responses::GigInvitationListResponse.new(response.body) if response.body['object'] == 'list'
      end
    end
  end
end
