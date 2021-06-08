module CirroIO
  module Client
    class Payout < Base
      belongs_to :app_worker
    end
  end
end
