module CirroIOV2
  module Responses
    class GigInvitationResponse
      GIG_INVITATION_PARAMS = [:id, :object, :status, :gig_id, :user_id].freeze

      def self.build(body)
        gig_invitation = Struct.new(*GIG_INVITATION_PARAMS)
        gig_invitation.new(*body.slice(*GIG_INVITATION_PARAMS).values)
      end
    end

    class GigInvitationListResponse
      GIG_INVITATION_PARAMS = [:object, :url, :has_more, :data].freeze

      def self.build(body)
        gig_invitation_list = Struct.new(*GIG_INVITATION_PARAMS)
        gig_invitation_list.new(
          *body.slice(*GIG_INVITATION_PARAMS.excluding(:data)).values,
          body[:data].map { |gig_invitation| GigInvitationResponse.build(gig_invitation) },
        )
      end
    end
  end
end
