module CirroIO
  module Client
    class Configuration
      def app_id(value = nil)
        @app_id = value unless value.nil?
        raise 'app_id must be defined' unless defined?(@app_id)

        @app_id
      end

      def private_key_path(value = nil)
        @private_key_path = value unless value.nil?
        raise 'private_key_path must be defined' unless defined?(@private_key_path)

        @private_key_path
      end

      def site(value = nil)
        @site = value unless value.nil?
        raise 'site must be defined' unless defined?(@site)

        @site
      end

      def api_version
        'v1'
      end
    end
  end
end
