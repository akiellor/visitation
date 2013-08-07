require 'visitation/control'
require 'visitation/decorator'

module Visitation
  class AddressableObjectTree
    def initialize tree
      @tree = tree
    end

    def unwrap
      @tree
    end

    def get address
      find_node_at(address)
    end

    def has_address?(address)
      return true if address.root?

      has_address?(address.parent) && Decorator.decorate(get(address.parent)).has_key?(address.head)
    end

    def put address, value
      if address.root?
        @tree = value
        return
      end

      parent = address.parent

      parent.descend do |parent|
        with_node_at(parent.parent) do |node|
          node[parent.head] = {} unless node[parent.head]
        end
      end

      with_node_at(parent) do |node|
        node[address.head] = value
      end
    end

    def replace address, replacement
      with_node_at(address.parent) do |node|
        node[address.head] = replacement
      end
    end

    def with_node_at(address)
      return unless has_address?(address)

      find_node_at(address).tap do |node|
        yield node
      end
    end

    private

    def find_node_at(address)
      address.get.reduce(@tree) { |subtree, key| subtree[key] if subtree }
    end
  end
end
