module CirroIO
  module Client
    class Gig < Base
      include CirroIO::Client::BulkActionHelper

      has_one :worker_filter
      has_many :gig_tasks
      has_many :gig_results
      has_many :gig_time_activities

      def bulk_create_with(worker_filter, gig_tasks)
        payload = { data: { attributes:, relationships: {} } }
        payload[:data][:relationships][:gig_tasks] = gig_tasks.map(&:attributes)
        payload[:data][:relationships][:worker_filter] = worker_filter.attributes

        response = self.class.custom_post('bulk/gigs', format_to_dashed_keys(payload))

        self.class.parser.parse(self.class, response).first
      end

      def bulk_archive_with(gig_results, gig_time_activities)
        payload = { data: { relationships: {} } }
        payload[:data][:relationships][:gig_results] = gig_results.map do |result|
          result.attributes.merge({ relationships: {
                                    'app-worker': { data: result.app_worker.attributes },
                                    'gig-task': { data: result.gig_task.attributes },
                                  } })
        end
        payload[:data][:relationships][:gig_time_activities] = gig_time_activities.map do |activity|
          activity.attributes.merge({ relationships: { 'app-worker': { data: activity.app_worker.attributes } } })
        end

        response = self.class.custom_post("bulk/gigs/#{id}/archive", format_to_dashed_keys(payload))

        self.class.parser.parse(self.class, response).first
      end
    end
  end
end
