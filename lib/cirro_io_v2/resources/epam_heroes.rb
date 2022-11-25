module CirroIOV2
  module Resources
    class EPAMHeroes < Base
      def create(params)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::GigResponse.new(response.body)
      end
    end
  end
end
