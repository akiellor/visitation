require 'visitation/address'
require 'visitation/address_trace'
require 'visitation/addressable_object_tree'

module Visitation
  module Visitors
    class TemplateVisitor
      include AddressTrace

      def initialize new_values
        super
        @new_values = AddressableObjectTree.new(new_values)
        @result = AddressableObjectTree.new({})
      end

      def visit_array key, value, control
        template_element = value.first

        if @new_values.has_address?(address) && @new_values.get(address).is_a?(Array)
          new_array = @new_values.get(address).map do |new_value_element|
            Visitation::Visitors.merge_template template_element, new_value_element
          end
        elsif @new_values.has_address?(address)
          new_array = @new_values.get(address)
        else
          new_array = value
        end

        @result.put address, new_array

        control.dont_go_deeper!
      end

      def visit_leaf key, value
        if @new_values.has_address?(address)
          @result.put address, @new_values.get(address)
        else
          @result.put address, value
        end
      end

      def result
        @result.unwrap
      end
    end
  end
end
