require 'visitation/addressable_object_tree'
require 'visitation/address_trace'
require 'visitation/address'

module Visitation
  module Visitors
    class DotNotationExpandingVisitor
      include Visitation::AddressTrace

      def initialize
        super
        @output = nil
      end

      def get
        @output.unwrap
      end

      def visit_root value
        @output = Visitation::AddressableObjectTree.new(value.class.new)
      end

      def visit_hash key, value
        store address, key, {}
      end

      def visit_array key, value
        store address, key, []
      end

      def visit_leaf key, value
        store address, key, value
      end

      private

      def store address, key, value
        address = build_address(key, address)
        @output.put address, value
      end

      def build_address key, address
        key.class < Numeric ? address : key.split(".")[0..-1].reduce(address.parent, &:push)
      end
    end
  end
end
