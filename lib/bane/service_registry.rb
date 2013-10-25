module Bane

  class ServiceRegistry
    def all_servers
      Behaviors.constants.reject { |name| name === :BasicBehavior }.map { |name| Behaviors.const_get(name) }.grep(Class)
    end

    def all_server_names
      all_servers.map(&:simple_name).sort
    end

    def create(behavior_names, starting_port, host)
      behaviors = behavior_names.map { |behavior| find(behavior) }

      behaviors.map.with_index do |behavior, index|
        BehaviorServer.new(starting_port + index, behavior.new, host)
      end
    end

    def create_all(starting_port, host)
      create(all_server_names, starting_port, host)
    end

    private

    def find(behavior_name)
      all_servers.find { |behavior| behavior.simple_name == behavior_name }.tap do |server|
        raise UnknownBehaviorError.new(behavior_name) unless server
      end
    end
  end

  class UnknownBehaviorError < RuntimeError
    def initialize(name)
      super "Unknown behavior: #{name}"
    end
  end

end