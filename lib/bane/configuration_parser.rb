module Bane

  class ConfigurationParser

    attr_reader :configurations

    def initialize(*args)
      @configurations = []

      @configurations = case args[0]
        when String, Integer
          map_integer_and_behavior_arguments(*args)
        when Hash
          map_hash_arguments(args[0])
        else
          raise ConfigurationError, "Unknown configuration arguments #{args.inspect}"
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
        @configurations << create_server(port + index, find(behavior))
      end
      @configurations
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
      options.each_pair do |key, value|
        @configurations << extract_configuration_from(key, value)
      end
      @configurations
    end

    def extract_configuration_from(port, value)
      case value
        when Module
          behavior = value
          create_server(port, behavior)
        when Hash
          behavior = value.delete(:behavior)
          options = value
          create_server(port, behavior, options)
        else
          raise ConfigurationError, "Unknown configuration option: #{value.inspect}"
      end
    end

    def create_server(port, behavior, options = {})
      BehaviorServer.new(port, behavior.new(options), BehaviorServer::DEFAULT_HOST)
    end

  end

end

# Helper method to easily create configuration.
module Kernel
  def Configuration(*args)
    Bane::ConfigurationParser.new(*args).configurations
  end
end