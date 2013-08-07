require 'visitation/address'

module Visitation
  module AddressTrace
    def initialize *args
      @address = Address.new
    end

    def address
      @address
    end

    def start key, value
      @address = address.push(key)
    end

    alias_method :start_hash, :start
    alias_method :start_array, :start
    alias_method :start_leaf, :start

    def end key, value
      @address = @address.parent
    end

    alias_method :end_hash, :end
    alias_method :end_array, :end
    alias_method :end_leaf, :end
  end
end
