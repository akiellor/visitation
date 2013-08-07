require 'visitation/address'
require 'visitation/address_trace'
require 'visitation/addressable_object_tree'

module Visitation
  module Visitors
    class PartialViewVisitor
      include AddressTrace

      def initialize document
        super
        @document = AddressableObjectTree.new(document)
        @view = AddressableObjectTree.new({})
      end

      def view
        @view.unwrap
      end

      def visit_hash key, value, control
        if @document.has_address?(address)
          @view.put address, value.empty? ? @document.get(address) : {}
        else
          control.dont_go_deeper!
        end
      end

      def visit_array key, value, control
        if @document.has_address?(address)
          original_array = @document.get(address)
          @view.put address, [nil] * original_array.size
        else
          control.dont_go_deeper!
        end
      end

      def visit_leaf key, value
        if @document.has_address?(address)
          @view.put address, @document.get(address)
        end
      end
    end
  end
end
