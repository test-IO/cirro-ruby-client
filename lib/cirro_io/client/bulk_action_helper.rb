module CirroIO
  module Client
    module BulkActionHelper
      def format_to_dashed_keys(params)
        params.deep_transform_keys { |key| key.to_s.gsub('_', '-') }
      end
    end
  end
end
