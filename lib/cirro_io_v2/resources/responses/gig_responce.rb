module CirroIOV2
  module Resources
    module Responses
      class GigResponce
        GIG_PARAMS = %i[id object title description url start_at end_at total_seats invitation_mode
                        filter_query tasks notification_payload epam_options].freeze

        def self.create(body)
          gig = Struct.new(*GIG_PARAMS)
          gig.new(*body.slice(*GIG_PARAMS).values)
        end
      end
    end
  end
end
