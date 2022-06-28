require 'cirro_io/client/version'

require 'cirro_io_v2/errors/http_error'
require 'cirro_io_v2/request_clients/base'
require 'cirro_io_v2/request_clients/jwt'

module CirroIOV2
  class Client
    attr_accessor :request_client
    attr_reader :options

    DEFAULT_OPTIONS = {
      site: 'https://api.cirro.io',
      api_version: 'v2',
      auth_type: :jwt
    }.freeze

    DEFINED_OPTIONS = (DEFAULT_OPTIONS.keys + [:private_key, :client_id]).freeze

    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge(options)

      unknown_options = options.keys.reject { |o| DEFINED_OPTIONS.include?(o) }
      raise ArgumentError, "Unknown option(s) given: #{unknown_options}" unless unknown_options.empty?

      case options[:auth_type]
      when :jwt
        @request_client = RequestClients::Jwt.new(base_url: "#{options[:site]}/#{options[:api_version]}", client_id: options[:client_id], private_key: options[:private_key])
      else
        raise ArgumentError, 'Options: ":auth_type" must be ":jwt"'
      end
    end
  end
end
