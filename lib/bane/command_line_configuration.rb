module Bane
  class CommandLineConfiguration
    def initialize(system)
      @service_maker = ServiceMaker.new
      @arguments_parser = ArgumentsParser.new
      @system = system
    end

    def process(args)
      create_servers_with(@arguments_parser.parse(args))
    rescue ConfigurationError => ce
      @system.incorrect_usage([ce.message, @arguments_parser.usage].join("\n"))
    end

    private

    def create_servers_with(arguments)
      if arguments.valid?
        create(arguments.services, arguments.port, arguments.host)
      else
        @system.exit_success(@arguments_parser.usage)
      end
    end

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
    def exit_success(message)
      puts message
      exit(0)
    end

    def incorrect_usage(message)
      puts message
      exit(1)
    end
  end

end
