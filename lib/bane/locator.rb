module Bane

  module Behaviors

    class Locator
      def find(behavior)
        case behavior
          when String
            raise UnknownBehaviorError.new(behavior) unless Behaviors.const_defined?(behavior.to_sym)
            Behaviors.const_get(behavior)
          when Module
            behavior
        end
      end
    end

  end

  class UnknownBehaviorError < RuntimeError
    def initialize(name)
      super "Unknown behavior: #{name}"
    end
  end
end