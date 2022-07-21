module CirroIOV2
  module Resources
    class User < Base
      def find(id)
        response = client.request_client.request(:get, "#{resource_root}/#{id}")
        OpenStruct.new(response.body)
      end
    end
  end
end
