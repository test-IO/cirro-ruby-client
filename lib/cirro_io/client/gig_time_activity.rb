module CirroIO
  module Client
    class GigTimeActivity < Base
      has_one :gig
      has_one :app_worker
    end
  end
end
