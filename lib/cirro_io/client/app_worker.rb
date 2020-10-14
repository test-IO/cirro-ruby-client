module CirroIO
  module Client
    class AppWorker < Base
      has_one :app_user

      def self.resource_name
        'app-workers'
      end
    end
  end
end
