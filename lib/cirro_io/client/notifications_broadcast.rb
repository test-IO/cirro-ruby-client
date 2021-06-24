module CirroIO
  module Client
    class NotificationsBroadcast < Base
      has_one :channel
      has_one :worker_filter
    end
  end
end
