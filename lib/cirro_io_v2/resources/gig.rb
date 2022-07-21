module CirroIOV2
  module Resources
    class Gig < Base
      def create(title:, description:, url:, start_at:, end_at:, total_seats:, invitation_mode:, filter_query:,
                 tasks:, notification_payload: nil, epam_options: nil)

        body = { title: title, description: description, url: url, start_at: start_at, end_at: end_at,
                 total_seats: total_seats, invitation_mode: invitation_mode, filter_query: filter_query, tasks: tasks,
                 notification_payload: notification_payload, epam_options: epam_options }
        # TODO: should I have some validations for body params?
        response = client.request_client.request(:post, resource_root, body: body)
        OpenStruct.new(response.body)
      end
    end
  end
end
