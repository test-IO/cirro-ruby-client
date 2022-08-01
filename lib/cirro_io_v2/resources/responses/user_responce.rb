module CirroIOV2
  module Resources
    module Responses
      class UserResponce
        USER_PARAMS = %i[id object first_name last_name time_zone screen_name country_code epam worker].freeze

        def self.create(body)
          gig = Struct.new(*USER_PARAMS)
          gig.new(*body.slice(*USER_PARAMS).values)
        end
      end
    end
  end
end
