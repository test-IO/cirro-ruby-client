module CirroIOV2
  module Resources
    class User < Base
      def find(id)
        response = client.request_client.request(:get, "#{resource_root}/#{id}")
        CirroIOV2::Responses::UserResponse.build(response.body)
      end
    end
  end
end
