module Bane

  def self.find_makeables
    Hash[Bane::Behaviors::EXPORTED.map { |behavior| [behavior.unqualified_name, BehaviorMaker.new(behavior)] }]
    .merge(Hash[Bane::Services::EXPORTED.map { |service| [service.unqualified_name, service] }])
  end

  class CommandLineConfiguration

    def initialize(system, makeables)
      @service_maker = ServiceMaker.new(makeables)
      @arguments_parser = ArgumentsParser.new(makeables.keys)
      @system = system
    end

    def process(args)
      arguments = @arguments_parser.parse(args)
      create(arguments.services, arguments.port, arguments.host)
    rescue ConfigurationError => ce
      @system.incorrect_usage([ce.message, @arguments_parser.usage].join("\n"))
    end

    private

    def create(services, port, host)
      if services.any?
        @service_maker.create(services, port, host)
      else
        @service_maker.create_all(port, host)
      end
    rescue UnknownServiceError => ube
      raise ConfigurationError, ube.message
    end

  end

  class ConfigurationError < RuntimeError;
  end

  class SystemAdapter
    def incorrect_usage(message)
      puts message
      exit(1)
    end
  end

end
