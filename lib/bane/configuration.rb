module Bane

  class Configuration

    include Enumerable

    def initialize(*args)
      @configurations = []

      case args[0]
        when String
          map_integer_and_behavior_arguments(*args)
        when Integer
          map_integer_and_behavior_arguments(*args)
        when Hash
          map_hash_arguments(args[0])
        else
          raise ConfigurationError, "Unknown configuration arguments #{args.inspect}"
      end
    end

    def each
      @configurations.each do |entry|
        yield entry.port, entry.server
      end
    end

    private

    def map_integer_and_behavior_arguments(*args)
      port = Integer(args.shift)

      behavior_classes = args
      behavior_classes = ServiceRegistry.all_servers if behavior_classes.empty?

      setup_linear_ports(port, behavior_classes)
    end

    def setup_linear_ports(port, behavior_classes)
      behavior_classes.each_with_index do |behavior, index|
        @configurations << ConfigurationRecord.new(port + index, find(behavior))
      end
    end

    def find(behavior)
      case behavior
        when String
          raise UnknownBehaviorError.new(behavior) unless Behaviors.const_defined?(behavior.to_sym)
          Behaviors.const_get(behavior)
        when Module
          behavior
        else
          raise UnknownBehaviorError.new(behavior)
      end
    end

    def map_hash_arguments(options)
      options.each_pair do |port, behavior|
        @configurations << ConfigurationRecord.new(port, behavior)
      end
    end

    ConfigurationRecord = Struct.new("ConfigurationRecord", :port, :server)
    
  end

  class ConfigurationError < RuntimeError; end

  class UnknownBehaviorError < RuntimeError
    def initialize(name)
      super "Unknown behavior: #{name}"
    end
  end

end