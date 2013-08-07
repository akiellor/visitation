module Visitation
  module Decorator
    def self.decorate object
      RootComponent.new(object)
    end

    module ConditionalVisitation
      def visit_if_present visitor, event, *args
        if visitor.respond_to? event
          method = visitor.method(event)
          visitor.send(event, *args[0...method.arity])
        end
      end
    end

    class RootComponent
      include ConditionalVisitation

      def initialize root
        @root = root
      end

      def accept visitor
        control = Control.new
        visit_if_present visitor, :start_root, @root
        visit_if_present visitor, :visit_root, @root, control
        if control.go_deeper?
          each {|key, value| COMPONENT_MAPPINGS[value.class].new(key, value).accept(visitor) }
        end
        visit_if_present visitor, :end_root, @root
      end

      def each &block
        COMPONENT_MAPPINGS[@root.class].new("root", @root).each &block
      end

      def has_key? key
        COMPONENT_MAPPINGS[@root.class].new("root", @root).has_key? key
      end
    end

    class HashComponent
      include ConditionalVisitation

      def initialize name, hash
        @name = name
        @hash = hash
      end

      def accept visitor
        control = Control.new
        visit_if_present visitor, :start_hash, @name, @hash
        visit_if_present visitor, :visit_hash, @name, @hash, control
        if control.go_deeper?
          each {|key, value| COMPONENT_MAPPINGS[value.class].new(key, value).accept(visitor) }
        end
        visit_if_present visitor, :end_hash, @name, @hash
      end

      def each &block
        @hash.each &block
      end

      def has_key? key
        @hash.has_key? key
      end
    end

    class ArrayComponent
      include ConditionalVisitation

      def initialize name, array
        @name = name
        @array = array
      end

      def accept visitor
        control = Control.new
        visit_if_present visitor, :start_array, @name, @array
        visit_if_present visitor, :visit_array, @name, @array, control
        if control.go_deeper?
          each {|key, value| COMPONENT_MAPPINGS[value.class].new(key, value).accept(visitor) }
        end
        visit_if_present visitor, :end_array, @name, @array
      end

      def each &block
        @array.each_with_index {|value, index| block.call(index, value) }
      end

      def has_key? key
        (0...@array.size).include? key
      end
    end

    class LeafComponent
      include ConditionalVisitation

      def initialize key, value
        @key = key
        @value = value
      end

      def accept visitor
        visit_if_present visitor, :start_leaf, @key, @value
        visit_if_present visitor, :visit_leaf, @key, @value
        visit_if_present visitor, :end_leaf, @key, @value
      end

      def each
        yield @key, @value
      end

      def has_key? key
        false
      end
    end

    COMPONENT_MAPPINGS = Hash.new(LeafComponent).merge({Hash => HashComponent, Array => ArrayComponent})
  end
end