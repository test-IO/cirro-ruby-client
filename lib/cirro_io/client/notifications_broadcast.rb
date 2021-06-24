module CirroIO
  module Client
    class NotificationsBroadcast < Base
      has_one :channel, class_name: 'NotificationsChannel'
      has_one :worker_filter
    end
  end
end
