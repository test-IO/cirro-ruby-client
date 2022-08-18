module CirroIO
  module Client
    class NotificationsBroadcast < Base
      has_one :topic, class_name: 'NotificationsTopic'
      has_one :worker_filter
    end
  end
end
