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
      :NotificationTemplateListResponse,
    ].freeze

    DELETE_RESPONSES = [
      :GigDeleteResponse,
      :PayoutDeleteResponse,
      :NotificationTemplateDeleteResponse,
      :NotificationLayoutTemplateDeleteResponse,
      :NotificationTopicDeleteResponse,
    ].freeze

    UserResponse = Struct.new(:id,
                              :object,
                              :first_name,
                              :last_name,
                              :time_zone,
                              :birthday,
                              :country_code,
                              :epam,
                              :worker,
                              :anonymous_email,
                              keyword_init: true) do
      include Base
    end

    UserNotificationPreferenceResponse = Struct.new(:id, :object, :locale, :topics, keyword_init: true) do
      self::NESTED_RESPONSES = { topics: :NotificationTopicPreferenceListResponse }.freeze
      include Base
    end

    SpaceInvitationResponse = Struct.new(:id,
                                         :object,
                                         :token,
                                         :subject,
                                         :email,
                                         :name,
                                         :inviter_name,
                                         :skip_background_check,
                                         :expires_at,
                                         keyword_init: true) do
      include Base
    end

    InvitationNotificationTopicResponse = Struct.new(:id, :object, :name, keyword_init: true)
    GigResponse = Struct.new(:id,
                             :object,
                             :title,
                             :description,
                             :url,
                             :start_at,
                             :end_at,
                             :archived_at,
                             :total_seats,
                             :seats_min,
                             :seats_max,
                             :invitation_mode,
                             :filter_query,
                             :tasks,
                             :notification_payload,
                             :invitation_notification_topic,
                             :epam_options,
                             keyword_init: true) do
      self::NESTED_RESPONSES = { tasks: :GigTaskListResponse, invitation_notification_topic: :InvitationNotificationTopicResponse }.freeze
      include Base
    end

    GigTaskResponse = Struct.new(:id, :object, :title, :base_price, keyword_init: true) do
      include Base
    end

    GigInvitationResponse = Struct.new(:id, :object, :status, :gig_id, :user_id, :no_reward, :epam_bench_status, keyword_init: true) do
      include Base
    end

    GigTimeActivityResponse = Struct.new(:id, :object, :gig_id, :user_id, :description, :duration_in_ms, :date, keyword_init: true) do
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
                                   :currency,
                                   :cost_center_key,
                                   :cost_center_data,
                                   keyword_init: true) do
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
                                :currency,
                                :cost_center_key,
                                :cost_center_data,
                                keyword_init: true) do
      include Base
    end

    NotificationTopicPreferenceResponse = Struct.new(:id, :object, :preferences, :notification_topic_id, :user_id, keyword_init: true) do
      include Base
    end

    NotificationLocaleResponse = Struct.new(:id, :object, :locale, :default, :configurations, keyword_init: true) do
      self::NESTED_RESPONSES = { configurations: :NotificationConfigurationListResponse }.freeze
      include Base
    end

    NotificationConfigurationResponse = Struct.new(:id, :object, :deliver_by, :format, :kind, :locale, keyword_init: true) do
      include Base
    end

    NotificationLayoutResponse = Struct.new(:id, :object, :name, :templates, keyword_init: true) do
      self::NESTED_RESPONSES = { templates: :NotificationLayoutTemplateListResponse }.freeze
      include Base
    end

    NotificationLayoutTemplateResponse = Struct.new(:id, :object, :notification_configuration_id, :notification_layout_id, :body, keyword_init: true) do
      include Base
    end

    NotificationTopicResponse = Struct.new(:id, :object, :name, :notification_layout_id, :preferences, :templates, keyword_init: true) do
      self::NESTED_RESPONSES = { templates: :NotificationTemplateListResponse }.freeze
      include Base
    end

    NotificationTemplateResponse = Struct.new(:id, :object, :notification_configuration_id, :notification_topic_id, :subject, :body, keyword_init: true) do
      include Base
    end

    NotificationBroadcastResponse = Struct.new(:id, :object, :payload, :recipients, :notification_topic_id, keyword_init: true) do
      include Base
    end

    EpamHeroesBadgeResponse = Struct.new(:content, :refs, :paging, :hasMoreResults, keyword_init: true) do
      include Base
    end

    # cover the list and delete responses
    def self.const_missing(name)
      return const_get(name) if const_defined? name

      struct = nil
      struct = Struct.new(:object, :url, :has_more, :data, keyword_init: true) if LIST_RESPONSES.include?(name)
      struct = Struct.new(:id, :object, :deleted, keyword_init: true) if DELETE_RESPONSES.include?(name)

      return unless struct.present?

      klass = Class.new(struct) { include Base }
      const_set(name, klass)
    end
  end
end
