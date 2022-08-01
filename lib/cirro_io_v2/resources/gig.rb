require 'cirro_io_v2/responses/gig_response'

module CirroIOV2
  module Resources
    class Gig < Base
      def create(params)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::GigResponse.build(response.body)
      end
    end
  end
end
