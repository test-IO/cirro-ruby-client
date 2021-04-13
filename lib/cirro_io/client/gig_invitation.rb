module CirroIO
  module Client
    class GigInvitation < Base
      include CirroIO::Client::BulkActionHelper

      has_one :gig

      def bulk_create_with(worker_filter, auto_accept: false)
        payload = { data: { attributes: attributes.merge(worker_filter: worker_filter.attributes, auto_accept: auto_accept) } }

        response = self.class.custom_post("bulk/gigs/#{gig.id}/gig_invitations", format_to_dashed_keys(payload))

        self.class.parser.parse(self.class, response)
      end
    end
  end
end
