require 'visitation/address_trace'

module Visitation
  module Visitors
    class CoercingVisitor
      include Visitation::AddressTrace

      def initialize description, &coercer
        super
        @coercer = coercer || Visitation.coercer
        @description = Visitation::AddressableObjectTree.new(description)
        @view = Visitation::AddressableObjectTree.new({})
      end

      def view
        @view.unwrap
      end

      def visit_hash key, value
        @view.put address, {}
      end

      def visit_array key, value
        @view.put address, []
      end

      def visit_leaf key, value
        @view.put address, @coercer.call(value, @description.get(address))
      end
    end
  end
end