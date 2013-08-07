require 'visitation'

module Visitation
  module Visitors
    class DeepMergingVisitor
      include Visitation::AddressTrace

      class Identifier < Struct.new(:collection_address)
        def initialize collection_address, *identifier_addresses
          self.collection_address = collection_address
          @identifier_addresses = identifier_addresses
        end

        def get document
          @identifier_addresses.map {|id| Visitation::AddressableObjectTree.new(document).get(id)}
        end
      end

      def initialize document, identifiers = []
        super
        @result = Visitation::AddressableObjectTree.new(Marshal.load(Marshal.dump(document)))
        @identifiers = identifiers
      end

      def visit_root value
        visit_array nil, value
      end

      def visit_array key, value
        identifier = identifier_for(address)
        if identifier
          result = Visitation::Visitors.visit_and_deep_merge index(identifier, @result.get(address)), index(identifier, value)
          @result.put address, result.values
        end
      end

      def visit_leaf key, value
        @result.put address, value unless identified_collection? address
      end

      def result
        @result.unwrap
      end

      private

      def identified_collection? address
        !identifier_for(address).nil?
      end

      def identifier_for address
        @identifiers.detect { |id| id.collection_address.parent_of?(address) }
      end

      def index identifier, array
        Hash[array.map do |element|
          [identifier.get(element), element]
        end]
      end
    end
  end
end