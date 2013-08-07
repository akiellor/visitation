require 'visitation/visitor'
require 'visitation/visitors/field_visitor'
require 'visitation/visitors/partial_view_visitor'
require 'visitation/visitors/dot_notation_expanding_visitor'
require 'visitation/visitors/coercing_visitor'
require 'visitation/visitors/deep_merging_visitor'
require 'visitation/visitors/template_visitor'

module Visitation
  module Visitors
    class << self
      def visit_field hash_or_array, field_name, &block
        visitor = FieldVisitor.new(field_name)
        Visitation::Visitor.visit hash_or_array, visitor
        visitor.collector.each &block
      end

      def visit_for_view hash_or_array, view_description
        visitor = PartialViewVisitor.new(hash_or_array)
        Visitation::Visitor.visit view_description, visitor
        visitor
      end

      def visit_and_expand_dot_notation hash_or_array
        visitor = DotNotationExpandingVisitor.new
        Visitation::Visitor.visit hash_or_array, visitor
        visitor
      end

      def visit_and_coerce hash_or_array, coercion_description, &block
        visitor = CoercingVisitor.new(coercion_description, &block)
        Visitation::Visitor.visit hash_or_array, visitor
        visitor
      end

      def visit_and_deep_merge hash_or_array, partial_hash_or_array, identifiers = []
        visitor = DeepMergingVisitor.new(hash_or_array, identifiers)
        Visitation::Visitor.visit partial_hash_or_array, visitor
        visitor.result
      end

      def merge_template template_hash, new_values
        visitor = TemplateVisitor.new(new_values)
        Visitation::Visitor.visit template_hash, visitor
        visitor.result
      end
    end
  end
end