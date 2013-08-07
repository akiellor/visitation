module Visitation
  module Visitors
    class FieldVisitor
      attr_accessor :collector

      def initialize field_name
        @collector = []
        @field_name = field_name
      end

      def visit_array key, array
        if key == @field_name
          @collector << array
        end
      end

      def visit_hash key, hash
        if key == @field_name
          @collector << hash
        end
      end

      def visit_leaf key, value
        if key == @field_name
          @collector << value
        end
      end
    end
  end
end
