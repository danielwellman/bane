module Bane

  class ServiceMaker
    def all_service_names
      (all_behaviors + all_services).map(&:unqualified_name).sort
    end

    def create(service_names, starting_port, host)
      makers = service_names.map { |service_name| find(service_name) }

      makers.map.with_index do |maker, index|
        maker.make(starting_port + index, host)
      end
    end

    def create_all(starting_port, host)
      create(all_service_names, starting_port, host)
    end

    private

    def all_behaviors
      Behaviors.constants.map { |name| Behaviors.const_get(name) }.grep(Class)
    end

    def all_services
      Services.constants.map { |name| Services.const_get(name) }.grep(Class)
    end

    def find(target_name)
      behavior = all_behaviors.find { |behavior| behavior.unqualified_name == target_name }
      return BehaviorMaker.new(behavior) if behavior
      service = all_services.find { |service| service.unqualified_name == target_name }
      return service if service

      raise UnknownServiceError.new(target_name) unless behavior
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