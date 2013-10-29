module Bane

  class ServiceMaker
    def initialize
      @behaviors = ClassesInNamespace.new(Bane::Behaviors)
      @services = ClassesInNamespace.new(Bane::Services)
    end

    def all_service_names
      (@behaviors.names + @services.names).sort
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

    def find(target_name)
      behavior = @behaviors.find(target_name)
      service = @services.find(target_name)

      if behavior
        BehaviorMaker.new(behavior)
      elsif service
        service
      else
        raise UnknownServiceError.new(target_name) unless behavior
      end
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

  class ClassesInNamespace
    attr_reader :namespace

    def initialize(namespace)
      @namespace = namespace
    end

    def all
      namespace.constants.map { |name| namespace.const_get(name) }.grep(Class)
    end

    def names
      all.map(&:unqualified_name)
    end

    def find(desired_name)
      all.find { |clazz| clazz.unqualified_name == desired_name }
    end
  end

end