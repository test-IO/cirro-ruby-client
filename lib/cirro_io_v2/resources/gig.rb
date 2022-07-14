module CirroIOV2
  module Resources
    class Gig < Base
      def create(body)
        client.request_client.request(:post, resource_root, body)
      end
    end
  end
end

