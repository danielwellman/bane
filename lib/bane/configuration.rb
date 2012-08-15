require 'optparse'

module Bane
  class Configuration
  	def self.from(args, failure_policy = method(:raise))
      config = self.new(args, failure_policy)
      config.parse
  	end

    def initialize(args, failure_policy)
      @args = args
      @failure_policy = failure_policy
    end

    def parse
      options = { :host => BehaviorServer::DEFAULT_HOST }

      begin
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
      rescue OptionParser::InvalidOption => io
        @failure_policy.call(io.message)
        return nil
      end

      if (@args.empty?)
        @failure_policy.call(option_parser.help)
        return nil;
      end

      # TODO Try to parse arguments here and catch, report errors to user
      port = Integer(@args[0])
      begin
        behaviors = @args.drop(1).map { |behavior| find(behavior) }
      rescue UnknownBehaviorError => ube
        @failure_policy.call(ube.message)
        return nil
      end

      behaviors = ServiceRegistry.all_servers if behaviors.empty?
      LinearPortMappedBehaviorConfiguration.new(port, behaviors, options[:host])
    end

    private 

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
