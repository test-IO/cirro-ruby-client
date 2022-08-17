module CirroIOV2
  module Responses
    module Base
      def initialize(body)
        body = body.deep_symbolize_keys
        if body[:object] == 'list'
          list_item_class = self.class.name.gsub('List', '').constantize
          values_hash = body.slice(*members.excluding(:data)).merge(
            data: body[:data].map { |list_item| list_item_class.new(list_item) },
          )
          super(*members.map { |attr| values_hash[attr] })
        elsif list_attribute(body)
          values_hash = body.slice(*members.excluding(list_attribute(body))).merge(
            list_attribute(body) => create_sub_resource(list_attribute(body), body[list_attribute(body)]),
          )
          super(*body.slice(*members).keys.map { |attr| values_hash[attr] })
        else
          super(*body.slice(*members).values)
        end
      end

      def list_attribute(data)
        data.keys.find { |key| data[key].is_a?(Hash) && data[key][:object] == 'list' }
      end

      def create_sub_resource(resource_name, body)
        sub_resource_class = "CirroIOV2::Responses::#{self.class::NESTED_RESPONSES[resource_name]}".constantize
        sub_resource_class.new(body)
      end
    end
  end
end
