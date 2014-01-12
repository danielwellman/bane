module Bane

  class ServiceMaker
    def initialize(makeables)
      @makeables = makeables
    end

    def create(service_names, starting_port, host)
      service_names
        .map { |service_name| makeables.fetch(service_name) { raise UnknownServiceError.new(service_name) } }
        .map.with_index { |maker, index| maker.make(starting_port + index, host) }
    end

    def create_all(starting_port, host)
      makeables.sort.map.with_index { |name_maker_pair, index| name_maker_pair.last.make(starting_port + index, host) }
    end

    private

    attr_reader :makeables
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