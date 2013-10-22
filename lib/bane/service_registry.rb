module Bane

  module ServiceRegistry
    def self.all_servers
      @servers ||= []
    end

    def self.all_server_names
      all_servers.map(&:simple_name).sort
    end

    def self.register(server)
      all_servers << server unless all_servers.include?(server)
    end

    def self.unregister(server)
      all_servers.delete server
    end

    def self.create(behavior_names, starting_port, host)
      behaviors = behavior_names.map { |behavior| find(behavior) }

      behaviors.map.with_index do |behavior, index|
        BehaviorServer.new(starting_port + index, behavior.new, host)
      end
    end

    def self.create_all(starting_port, host)
      create(all_server_names, starting_port, host)
    end

    def self.find(behavior_name)
      raise UnknownBehaviorError.new(behavior_name) unless Behaviors.const_defined?(behavior_name)
      Behaviors.const_get(behavior_name)
    end
  end

  class UnknownBehaviorError < RuntimeError
    def initialize(name)
      super "Unknown behavior: #{name}"
    end
  end

end