module Bane
  class Configuration
  	def self.from(args)
      if (args.size == 1)
        LinearPortMappedBehaviorConfiguration.new(Integer(args[0]), ServiceRegistry.all_servers)
      elsif (args.size >= 2)
        behaviors = args.drop(1).map { |behavior| find(behavior) }
        LinearPortMappedBehaviorConfiguration.new(Integer(args[0]), behaviors)
      else
        raise "nothing"
      end
  	end

    private 
    def self.find(behavior)
      # raise UnknownBehaviorError.new(behavior) unless Behaviors.const_defined?(behavior.to_sym)
      Behaviors.const_get(behavior)      
    end
  end

  private 
  
  class LinearPortMappedBehaviorConfiguration
    def initialize(port, behaviors)
      @port = port
      @behaviors = behaviors
    end

    def servers
      configurations = []
      @behaviors.each_with_index do |behavior, index|
        configurations << BehaviorServer.new(@port + index, behavior.new)
      end
      configurations
    end

  end

end
