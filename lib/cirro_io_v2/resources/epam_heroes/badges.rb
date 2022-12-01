module CirroIOV2
  module Resources
    module EpamHeroes
      class Badges < Base
        ENDPOINT_PATH = 'epam_heroes/badges'.freeze

        def create(params)
          response = client.request_client.request(:post, ENDPOINT_PATH, body: params)
          Responses::EpamHeroesBadgeResponse.new(response.body)
        end
      end
    end
  end
end
