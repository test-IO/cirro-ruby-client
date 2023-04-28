module CirroIOV2
  module Responses
    module Base
      def initialize(body)
        body = body.deep_symbolize_keys

        if body[:object] == 'list'
          list_item_class = self.class.name.gsub('List', '').constantize
          body[:data] = body[:data].map { |list_item| list_item_class.new(list_item) }
        end

        if self.class.const_defined?('NESTED_RESPONSES')
          self.class::NESTED_RESPONSES.each do |attribute_name, class_name|
            next unless members.include?(attribute_name)
            next unless body[attribute_name]

            body[attribute_name] = "CirroIOV2::Responses::#{class_name}".constantize.new(body[attribute_name])
          end
        end

        super(**body.slice(*members))
      end
    end
  end
end
