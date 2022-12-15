module CirroIOV2
  module Resources
    class Gig < Base
      def find(id)
        Responses::GigResponse.new(
          client.request_client.request(:get, [resource_root, id].join('/')).body,
        )
      end

      def create(params)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::GigResponse.new(response.body)
      end

      def archive(id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/archive", body: params)
        Responses::GigResponse.new(response.body)
      end

      def tasks(id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{id}/tasks", body: params)
        Responses::GigTaskResponse.new(response.body)
      end

      def update_task(gig_id, task_id, params)
        response = client.request_client.request(:post, "#{resource_root}/#{gig_id}/tasks/#{task_id}", body: params)
        Responses::GigTaskResponse.new(response.body)
      end
    end
  end
end
