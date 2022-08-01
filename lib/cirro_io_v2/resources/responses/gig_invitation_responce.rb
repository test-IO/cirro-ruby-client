module CirroIOV2
  module Resources
    module Responses
      class GigInvitationResponce
        GIG_INVITATION_PARAMS = %i[id object status gig_id user_id].freeze

        def self.create(body)
          gig = Struct.new(*GIG_INVITATION_PARAMS)
          gig.new(*body.slice(*GIG_INVITATION_PARAMS).values)
        end
      end

      class GigInvitationListResponce
        GIG_INVITATION_PARAMS = %i[object url has_more data].freeze

        def self.create(body)
          gig = Struct.new(*GIG_INVITATION_PARAMS)
          gig.new(
            *body.slice(*GIG_INVITATION_PARAMS.excluding(:data)).values,
            body[:data].map { |gig_invitation| GigInvitationResponce.create(gig_invitation) },
          )
          #  TODO: Should I do in this way?
        end
      end
    end
  end
end
