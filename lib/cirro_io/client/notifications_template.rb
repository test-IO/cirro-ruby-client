module CirroIO
  module Client
    class NotificationsTemplate < Base
      has_one :topic, class_name: 'NotificationsTopic'
    end
  end
end
