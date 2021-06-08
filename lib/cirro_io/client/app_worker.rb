module CirroIO
  module Client
    class AppWorker < Base
      has_one :app_user
      has_many :gig_invitations
      has_many :payouts
    end
  end
end
