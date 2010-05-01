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
        yield entry[:port], entry[:server]
      end
    end

    private

    def map_integer_and_behavior_arguments(*args)
      port = Integer(args.shift)

      behavior_classes = args

      if (behavior_classes.empty?)
        setup_linear_ports(port, ServiceRegistry.all_servers)
      else
        setup_linear_ports(port, behavior_classes)
      end
    end

    def setup_linear_ports(port, behavior_classes)
      locator = Behaviors::Locator.new
      behavior_classes.each_with_index do |behavior, index|
        @configurations << { :port => port + index, :server => locator.find(behavior) }
      end
    end

    def map_hash_arguments(options)
      locator = Behaviors::Locator.new
      options.each_pair do |port, behavior|
        @configurations << { :port => port, :server => locator.find(behavior) }
      end
    end

  end

  class ConfigurationError < RuntimeError; end
end