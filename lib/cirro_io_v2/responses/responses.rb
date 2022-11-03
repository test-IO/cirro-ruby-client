module CirroIOV2
  module Responses
    LIST_RESPONSES = [
      :GigTaskListResponse,
      :GigResultListResponse,
      :GigInvitationListResponse,
      :GigTimeActivityListResponse,
      :PayoutListResponse,
      :NotificationTopicPreferenceListResponse,
      :NotificationLocaleListResponse,
      :NotificationLayoutListResponse,
      :NotificationConfigurationListResponse,
      :NotificationLayoutTemplateListResponse,
      :NotificationTopicListResponse,
      :NotificationTemplateListResponse
    ].freeze

    UserResponse = Struct.new(:id, :object, :first_name, :last_name, :time_zone, :screen_name, :country_code, :epam, :worker) do
      include Base
    end

    UserNotificationPreferenceResponse = Struct.new(:id, :object, :locale, :topics) do
      self::NESTED_RESPONSES = { topics: :NotificationTopicListResponse }.freeze
      include Base
    end

    SpaceInvitationResponse = Struct.new(:id, :object, :token, :subject, :email, :name, :inviter_name, :skip_background_check, :expires_at) do
      include Base
    end

    GigResponse = Struct.new(:id,
                             :object,
                             :title,
                             :description,
                             :url,
                             :start_at,
                             :end_at,
                             :archived_at,
                             :total_seats,
                             :invitation_mode,
                             :filter_query,
                             :tasks,
                             :notification_payload,
                             :epam_options) do
      self::NESTED_RESPONSES = { tasks: :GigTaskListResponse }.freeze
      include Base
    end

    GigTaskResponse = Struct.new(:id, :object, :title, :base_price) do
      include Base
    end

    GigInvitationResponse = Struct.new(:id, :object, :status, :gig_id, :user_id) do
      include Base
    end

    GigTimeActivityResponse = Struct.new(:id, :object, :gig_id, :user_id, :description, :duration_in_ms, :date) do
      include Base
    end

    GigResultResponse = Struct.new(:id,
                                   :object,
                                   :gig_task_id,
                                   :user_id,
                                   :title,
                                   :description,
                                   :quantity,
                                   :multiplier,
                                   :delivery_date,
                                   :cost_center_key,
                                   :cost_center_data) do
      include Base
    end

    PayoutResponse = Struct.new(:id,
                                :object,
                                :amount,
                                :title,
                                :description,
                                :billing_date,
                                :reference_id,
                                :reference_type,
                                :user_id,
                                :cost_center_key,
                                :cost_center_data) do
      include Base
    end

    NotificationTopicPreferenceResponse = Struct.new(:id, :object, :preferences, :notification_topic_id, :user_id) do
      self::NESTED_RESPONSES = { preferences: :NotificationTopicPreferenceListResponse }.freeze
      include Base
    end

    NotificationLocaleResponse = Struct.new(:id, :object, :locale, :default, :configurations) do
      self::NESTED_RESPONSES = { configurations: :NotificationConfigurationListResponse }.freeze
      include Base
    end

    NotificationConfigurationResponse = Struct.new(:id, :object, :deliver_by, :format, :kind, :locale) do
      include Base
    end

    NotificationLayoutResponse = Struct.new(:id, :object, :name, :templates) do
      self::NESTED_RESPONSES = { templates: :NotificationLayoutTemplateListResponse }.freeze
      include Base
    end

    NotificationLayoutTemplateResponse = Struct.new(:id, :notification_configuration_id, :notification_layout_id, :body) do
      include Base
    end

    NotificationLayoutTemplateDeleteResponse = Struct.new(:id, :object, :deleted) do
      include Base
    end

    NotificationTopicResponse = Struct.new(:id, :object, :name, :notification_layout_id, :preferences, :templates) do
      self::NESTED_RESPONSES = { templates: :NotificationTemplateListResponse }.freeze
      include Base
    end

    NotificationTemplateResponse = Struct.new(:id, :object, :notification_configuration_id, :notification_topic_id, :subject, :body) do
      include Base
    end

    NotificationTemplateDeleteResponse = Struct.new(:id, :object, :deleted) do
      include Base
    end

    NotificationBroadcastResponse = Struct.new(:id, :object, :payload, :recipients, :notification_topic_id) do
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
