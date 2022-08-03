module CirroIOV2
  module Responses
    class UserResponse
      USER_PARAMS = %i[id object first_name last_name time_zone screen_name country_code epam worker].freeze

      def self.build(body)
        user = Struct.new(*USER_PARAMS)
        user.new(*body.slice(*USER_PARAMS).values)
      end
    end
  end
end
