module Visitation
  class Address
    attr_reader :address_array

    def initialize address_array = []
      @address_array = address_array
      @address_array.freeze
    end

    def push reference
      Address.new(@address_array + [reference])
    end

    def parent
      Address.new(@address_array[0..-2])
    end

    def parent_of? address
      ([Address.new] + address.parent.enum_for(:descend).to_a).any? {|e| e == self}
    end

    def head
      @address_array.last
    end

    def get
      @address_array
    end

    def root?
      @address_array.empty?
    end

    def == other
      self.address_array == other.address_array
    end

    def descend
      (0..(@address_array.size - 1)).each do |index|
        yield Address.new(@address_array[0..index])
      end
    end
  end
end
