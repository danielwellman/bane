require 'optparse'

module Bane
  class Configuration
  	def self.from(args, safe_exit_policy = method(:raise))
      config = self.new(args, safe_exit_policy)
      config.parse
  	end

    def initialize(args, safe_exit_policy)
      @args = args
      @safe_exit_policy = safe_exit_policy
    end

    def parse
      options = { :host => BehaviorServer::DEFAULT_HOST }
      option_parser = parse_options(options)

      if (@args.empty?)
        @safe_exit_policy.call(option_parser.help)
        return nil;
      end

      port = parse_port
      behaviors = parse_behaviors

      behaviors = ServiceRegistry.all_servers if behaviors.empty?
      LinearPortMappedBehaviorConfiguration.new(port, behaviors, options[:host])
    end

    private 

    def parse_options(options)
      option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: bane [options] port [behaviors]"
        opts.separator ""
        opts.on("-l", "--listen-on-localhost",
          "Listen on localhost, (#{BehaviorServer::DEFAULT_HOST}). [default]") do
          options[:host] = BehaviorServer::DEFAULT_HOST
        end
        opts.on("-a", "--listen-on-all-hosts", "Listen on all interfaces, (#{BehaviorServer::ALL_INTERFACES})") do
          options[:host] = BehaviorServer::ALL_INTERFACES
        end
      end
      option_parser.parse!(@args)
      option_parser
      rescue OptionParser::InvalidOption => io
        raise ConfigurationError, io.message
    end

    def parse_port
      Integer(@args[0])
      rescue ArgumentError => ae
        raise ConfigurationError, "Invalid port number: #{@args[0]}"
    end

    def parse_behaviors
      @args.drop(1).map { |behavior| find(behavior) }
      rescue UnknownBehaviorError => ube
        raise ConfigurationError, ube.message
    end

    def find(behavior)
      raise UnknownBehaviorError.new(behavior) unless Behaviors.const_defined?(behavior)
      Behaviors.const_get(behavior)      
    end

    class LinearPortMappedBehaviorConfiguration
      def initialize(port, behaviors, host)
        @starting_port = port
        @behaviors = behaviors
        @host = host
      end

      def servers
        configurations = []
        @behaviors.each_with_index do |behavior, index|
          configurations << BehaviorServer.new(@starting_port + index, @host, behavior.new)
        end
        configurations
      end

    end

  end
end
