require 'visitation/decorator'

module Visitation
  module Visitor
    def self.visit hash_or_array, visitor
      Decorator.decorate(hash_or_array).accept(visitor)
    end
  end
end


