module Bane

  def self.find_makeables
    Hash[Bane::Behaviors::Responders::EXPORTED.map { |responder| [responder.unqualified_name, ResponderMaker.new(responder)] }]
    .merge(Hash[Bane::Behaviors::Servers::EXPORTED.map { |server| [server.unqualified_name, server] }])
  end

  class CommandLineConfiguration

    def initialize(makeables)
      @behavior_maker = BehaviorMaker.new(makeables)
      @arguments_parser = ArgumentsParser.new(makeables.keys)
    end

    def process(args, &error_policy)
      arguments = @arguments_parser.parse(args)
      create(arguments.behaviors, arguments.port, arguments.host)
    rescue ConfigurationError => ce
      error_policy.call([ce.message, @arguments_parser.usage].join("\n"))
    end

    private

    def create(behaviors, port, host)
      if behaviors.any?
        @behavior_maker.create(behaviors, port, host)
      else
        @behavior_maker.create_all(port, host)
      end
    rescue UnknownBehaviorError => ube
      raise ConfigurationError, ube.message
    end

  end

  class ConfigurationError < RuntimeError;
  end

end
