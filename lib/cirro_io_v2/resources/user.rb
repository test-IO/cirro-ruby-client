module CirroIOV2
  module Resources
    class User < Base
      def find(id)
        response = client.request_client.request(:get, "#{resource_root}/#{id}")
        Responses::UserResponce.create(response.body)
      end
    end
  end
end
