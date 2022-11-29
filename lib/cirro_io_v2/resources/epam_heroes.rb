module CirroIOV2
  module Resources
    class EpamHeroes < Base
      def create(params)
        response = client.request_client.request(:post, resource_root, body: params)
        Responses::EpamHeroesResponse.new(response.body)
      end
    end
  end
end
