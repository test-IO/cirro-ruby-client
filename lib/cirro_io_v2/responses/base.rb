module CirroIOV2
  module Responses
    module Base
      def initialize(body)
        body = body.with_indifferent_access

        if body[:object] == 'list'
          list_item_class = self.class.name.gsub('List', '').constantize
          super(
            *body.slice(*members.excluding(:data)).values,
            body[:data].map { |list_item| list_item_class.new(list_item) },
          )
        else
          super(*body.slice(*members).values)
        end
      end
    end
  end
end
