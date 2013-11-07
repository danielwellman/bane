module Bane

  class ServiceMaker
    def initialize
      @everything = {}
      Bane::Behaviors::EXPORTED.each { |behavior| @everything[behavior.unqualified_name] = BehaviorMaker.new(behavior) }
      Bane::Services::EXPORTED.each { |service| @everything[service.unqualified_name] = service }
    end

    def all_service_names
      @everything.keys.sort
    end

    def create(service_names, starting_port, host)
      service_names
        .map { |service_name| @everything.fetch(service_name) { raise UnknownServiceError.new(service_name) } }
        .map.with_index { |maker, index| maker.make(starting_port + index, host) }
    end

    def create_all(starting_port, host)
      create(all_service_names, starting_port, host)
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
      Services::BehaviorServer.new(port, @behavior.new, host)
    end
  end

end