module CirroIOV2
  module Resources
    class User < Base
      def find(id)
        client.request_client.request(:get, "#{resource_root}/#{id}")

        # TODO: add some sort of ORM for response
      end
    end
  end
end
