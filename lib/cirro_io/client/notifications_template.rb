module CirroIO
  module Client
    class NotificationsTemplate < Base
      has_one :channel, class_name: 'NotificationsChannel'
    end
  end
end
