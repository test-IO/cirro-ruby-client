module CirroIO
  module Client
    class Gig < Base
      has_one :worker_invitation_filter
      has_many :gig_tasks

      # rubocop:disable Metrics/AbcSize
      def bulk_create_with(attrs)
        payload = { data: { attributes: attributes } }

        if attrs[:gig_tasks]
          payload[:data][:relationships] ||= {}
          payload[:data][:relationships][:gig_tasks] = attrs[:gig_tasks].map(&:attributes)
        end

        if attrs[:worker_invitation_filter]
          payload[:data][:relationships] ||= {}
          payload[:data][:relationships][:worker_invitation_filter] = attrs[:worker_invitation_filter].attributes
        end

        response = self.class.custom_post('bulk/gigs', payload)

        self.class.parser.parse(self.class, response).first
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
