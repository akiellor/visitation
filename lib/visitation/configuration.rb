module Visitation
  class Configuration
    def initialize
      @coercer = proc {|a, b| a}
    end

    def configure &block
      instance_eval &block
    end

    def coercer
      @coercer
    end

    def coerce_with &block
      @coercer = block
    end

    module Dsl
      def self.included base
        base.extend ClassMethods
        base.reset_configuration
      end

      module ClassMethods
        def configure &block
          @__configuration__.configure &block
        end

        def coercer
          @__configuration__.coercer
        end

        def reset_configuration
          @__configuration__ = Configuration.new
        end
      end
    end
  end
end

