require 'optparse'

module Bane
  class Configuration
    def initialize()
      @options = { :host => BehaviorServer::DEFAULT_HOST }
      @option_parser = init_option_parser
    end

    def parse(args)
      parse_options(@options, args)

      return [] if (args.empty?)

      port = parse_port(args[0])
      behaviors = parse_behaviors(args.drop(1))

      behaviors = ServiceRegistry.all_servers if behaviors.empty?
      LinearPortMappedBehaviorConfiguration.new(port, behaviors, @options[:host]).servers
    end

    def usage
      @option_parser.help
    end

    private 

    def init_option_parser
      OptionParser.new do |opts|
        opts.banner = "Usage: bane [options] port [behaviors]"
        opts.separator ""
        opts.on("-l", "--listen-on-localhost",
          "Listen on localhost, (#{BehaviorServer::DEFAULT_HOST}). [default]") do
          @options[:host] = BehaviorServer::DEFAULT_HOST
        end
        opts.on("-a", "--listen-on-all-hosts", "Listen on all interfaces, (#{BehaviorServer::ALL_INTERFACES})") do
          @options[:host] = BehaviorServer::ALL_INTERFACES
        end
      end
    end

    def parse_options(options, args)
      @option_parser.parse!(args)
      rescue OptionParser::InvalidOption => io
        raise ConfigurationError, io.message
    end

    def parse_port(port)
      Integer(port)
      rescue ArgumentError => ae
        raise ConfigurationError, "Invalid port number: #{port}"
    end

    def parse_behaviors(behaviors)
      behaviors.map { |behavior| find(behavior) }
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
