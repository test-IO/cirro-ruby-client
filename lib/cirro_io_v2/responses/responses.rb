module CirroIOV2
  module Responses
    LIST_RESPONSES = [
      :GigInvitationListResponse,
      :NotificationChannelPreferenceListResponse,
    ].freeze

    UserResponse = Struct.new(:id, :object, :first_name, :last_name, :time_zone, :screen_name, :country_code, :epam, :worker) do
      include Base
    end

    GigResponse = Struct.new(:id,
                             :object,
                             :title,
                             :description,
                             :url,
                             :start_at,
                             :end_at,
                             :total_seats,
                             :invitation_mode,
                             :filter_query,
                             :tasks,
                             :notification_payload,
                             :epam_options) do
      include Base
    end

    GigInvitationResponse = Struct.new(:id, :object, :status, :gig_id, :user_id) do
      include Base
    end

    NotificationChannelPreferenceResponse = Struct.new(:id, :object, :preferences, :notification_channel_id, :user_id) do
      include Base
    end

    # cover the list responses
    def self.const_missing(name)
      return const_get(name) if const_defined? name
      return unless LIST_RESPONSES.include? name

      klass = Class.new(Struct.new(:object, :url, :has_more, :data)) { include Base }
      const_set(name, klass)
    end
  end
end
