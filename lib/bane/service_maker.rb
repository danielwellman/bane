module Bane

  class ServiceMaker
    def all_server_names
      all_behaviors.map(&:unqualified_name).sort
    end

    def create(service_names, starting_port, host)
      makers = service_names.map { |service_name| find(service_name) }

      makers.map.with_index do |maker, index|
        maker.make(starting_port + index, host)
      end
    end

    def create_all(starting_port, host)
      create(all_server_names, starting_port, host)
    end

    private

    def all_behaviors
      Behaviors.constants.map { |name| Behaviors.const_get(name) }.grep(Class)
    end

    def find(behavior_name)
      behavior = all_behaviors.find { |behavior| behavior.unqualified_name == behavior_name }
      # if we did get a behavior, then return a BehaviorMaker
      # ... if we didnt' get one, then look it up in services and try to return a servicemaker
      # .. and if we didn't find anywhere, raise an error
      raise UnknownServiceError.new(behavior_name) unless behavior
      BehaviorMaker.new(behavior)
    end
  end

  class UnknownServiceError < RuntimeError
    def initialize(name)
      super "Unknown service: #{name}"
    end
  end

  class BehaviorMaker
    def initialize(behavior)
      @behavior = behavior
    end

    def make(port, host)
      BehaviorServer.new(port, @behavior.new, host)
    end
  end


end