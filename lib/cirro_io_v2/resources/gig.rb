module CirroIOV2
  module Resources
    class Gig < Base
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
    end
  end
end
