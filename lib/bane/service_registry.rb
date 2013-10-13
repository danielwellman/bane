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

    def self.find(behavior)
      raise UnknownBehaviorError.new(behavior) unless Behaviors.const_defined?(behavior)
      Behaviors.const_get(behavior)
    end

  end

  class UnknownBehaviorError < RuntimeError
    def initialize(name)
      super "Unknown behavior: #{name}"
    end
  end

end