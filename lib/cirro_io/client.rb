require 'json_api_client'

require 'cirro_io/client/version'
require 'cirro_io/client/configuration'
require 'cirro_io/client/response_debugging_middleware'
require 'cirro_io/client/jwt_authentication'
require 'cirro_io/client/base'
require 'cirro_io/client/gig_invitation'
require 'cirro_io/client/app_user'
require 'cirro_io/client/app_worker'
require 'cirro_io/client/worker_invitation_filter'
require 'cirro_io/client/gig_task'
require 'cirro_io/client/gig_result'
require 'cirro_io/client/gig_time_activity'
require 'cirro_io/client/gig'

module CirroIO
  module Client
    class Error < StandardError; end

    def self.configure
      yield configuration if block_given?
      Base.site = "#{configuration.site}/#{configuration.api_version}"
    end

    def self.configuration
      @configuration ||= Configuration.new
    end
  end
end
