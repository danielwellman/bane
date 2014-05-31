module Bane

  def self.find_makeables
    Hash[Bane::Behaviors::Responders::EXPORTED.map { |behavior| [behavior.unqualified_name, ResponderMaker.new(behavior)] }]
    .merge(Hash[Bane::Behaviors::Services::EXPORTED.map { |service| [service.unqualified_name, service] }])
  end

  class CommandLineConfiguration

    def initialize(makeables)
      @service_maker = ServiceMaker.new(makeables)
      @arguments_parser = ArgumentsParser.new(makeables.keys)
    end

    def process(args, &error_policy)
      arguments = @arguments_parser.parse(args)
      create(arguments.services, arguments.port, arguments.host)
    rescue ConfigurationError => ce
      error_policy.call([ce.message, @arguments_parser.usage].join("\n"))
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

end
