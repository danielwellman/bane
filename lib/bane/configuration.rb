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

      OptionParser.new do |opts|
        opts.banner = "Usage: bane [options] port [behaviors]"
        opts.on("-h", "--host HOST_ADDRESS", 
          "Listen on HOST_ADDRESS.  Defaults to (#{BehaviorServer::DEFAULT_HOST})") do |host|
          options[:host] = host
        end
      end.parse!(@args)

      if (@args.size == 1)
        LinearPortMappedBehaviorConfiguration.new(Integer(@args[0]), ServiceRegistry.all_servers, options[:host])
      elsif (@args.size >= 2)
        behaviors = @args.drop(1).map { |behavior| find(behavior) }
        LinearPortMappedBehaviorConfiguration.new(Integer(@args[0]), behaviors, options[:host])
      else
        raise "nothing"
      end
    end

    private 

    def find(behavior)
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
