require 'cirro_io/client/version'

require 'cirro_io_v2/errors/http_error'
require 'cirro_io_v2/errors/response_not_json_error'

require 'cirro_io_v2/request_clients/base'
require 'cirro_io_v2/request_clients/jwt'

Dir['lib/cirro_io_v2/resources/**/*.rb'].each { |f| require f.partition('/').last }
# TODO: Should I import the hole directory?

module CirroIOV2
  class Client
    attr_accessor :request_client
    attr_reader :options

    DEFAULT_OPTIONS = {
      site: 'https://api.cirro.io',
      api_version: 'v2',
      auth_type: :jwt,
    }.freeze

    DEFINED_OPTIONS = (DEFAULT_OPTIONS.keys + %i[private_key private_key_path client_id]).freeze

    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge(options)

      unknown_options = @options.keys.reject { |o| DEFINED_OPTIONS.include?(o) }
      raise ArgumentError, "Unknown option(s) given: #{unknown_options}" unless unknown_options.empty?

      # TODO: for now we only have jwt
      case @options[:auth_type]
      when :jwt
        private_key = OpenSSL::PKey::RSA.new(@options[:private_key]) if @options[:private_key]
        private_key = OpenSSL::PKey::RSA.new(File.read(@options[:private_key_path])) if @options[:private_key_path]
        @request_client = RequestClients::Jwt.new(base_url: "#{@options[:site]}/#{@options[:api_version]}",
                                                  client_id: @options[:client_id],
                                                  private_key: private_key)
      else
        raise ArgumentError, 'Options: ":auth_type" must be ":jwt"'
      end
    end

    # resources
    # rubocop:disable Naming/MethodName

    def User
      Resources::User.new(self)
    end

    def GigInvitation
      Resources::GigInvitation.new(self)
    end

    def Gig
      Resources::Gig.new(self)
    end

    def NotificationBroadcast
      # TODO
    end

    def NotificationChannelPreference
      # TODO
    end
    # rubocop:enable Naming/MethodName
  end
end
