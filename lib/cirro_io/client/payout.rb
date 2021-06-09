module CirroIO
  module Client
    class Payout < Base
      has_one :app_worker
    end
  end
end
