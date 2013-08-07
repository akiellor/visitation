require 'visitation'
require 'rspec/matchers/dsl'

module Visitation
  module Matchers
    extend RSpec::Matchers::DSL

    define :match_description do |description_hash|
      match do |actual_value|
        actual_view = Visitation::Visitors.visit_for_view actual_value, description_hash
        description_view = Visitation::Visitors.visit_and_coerce description_hash, actual_value

        @actual = actual_view.view
        @expected = description_view.view

        @actual == @expected
      end

      failure_message_for_should do |actual_value|
        "Expected #{actual_value.inspect} to match description #{description_hash.inspect}:\n\n#{view_message_for(@actual, @expected)}"
      end

      failure_message_for_should_not do |actual_value|
        "Expected #{actual_value.inspect} not to match description #{description_hash.inspect}:\n\n#{view_message_for(@actual, @description)}"
      end

      def view_message_for actual, expected
        "\tActual view: #{actual.inspect}\n\n\tDescription view: #{expected.inspect}\n\n"
      end
    end
  end
end
