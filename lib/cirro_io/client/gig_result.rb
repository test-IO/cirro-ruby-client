module CirroIO
  module Client
    class GigResult < Base
      has_one :app_worker
      has_one :gig_task
    end
  end
end
