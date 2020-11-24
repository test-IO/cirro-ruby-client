module CirroIO
  module Client
    class AppWorker < Base
      has_one :app_user
      has_many :gig_invitations

      def self.resource_name
        'app-workers'
      end
    end
  end
end
