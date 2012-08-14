require 'optparse'

module Bane
  class Configuration
  	def self.from(args)
      config = self.new(args)
      results = config.parse
  	end

    def initialize(args)
      @args = args
    end

    def parse
      options = { :host => BehaviorServer::DEFAULT_HOST }

      option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: bane [options] port [behaviors]"
        opts.separator ""
        opts.on("-l", "--listen-on-localhost",
          "Listen on localhost, (#{BehaviorServer::DEFAULT_HOST}). [default]") do
          options[:host] = BehaviorServer::DEFAULT_HOST
        end
        opts.on("-a", "--listen-on-all-hosts", "Listen on all interfaces, (0.0.0.0)") do
          options[:host] = BehaviorServer::ALL_INTERFACES
        end
      end
      option_parser.parse!(@args)

      port = Integer(@args[0])
      behaviors = @args.drop(1).map { |behavior| find(behavior) }

      if (behaviors.empty?)
        LinearPortMappedBehaviorConfiguration.new(port, ServiceRegistry.all_servers, options[:host])
      else
        LinearPortMappedBehaviorConfiguration.new(port, behaviors, options[:host])
      end
    end

    private 

    def find(behavior)
      #TODO throw exception if not found
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
