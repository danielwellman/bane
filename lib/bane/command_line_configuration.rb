require 'optparse'

module Bane
  class CommandLineConfiguration
    def initialize
      @service_maker = ServiceMaker.new
      @arguments_parser = ArgumentsParser.new
    end

    def parse(args)
      arguments = @arguments_parser.parse(args)

      return [] if arguments.empty?

      create(arguments.services, arguments.port, arguments.host)
    end

    def usage
      @arguments_parser.usage
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

  class ArgumentsParser
    def initialize
      @service_maker = ServiceMaker.new
      @options = {host: default_host}
      @option_parser = init_option_parser
    end

    def parse(args)
      @option_parser.parse!(args)

      return ParsedArguments.empty if args.empty?

      port = parse_port(args[0])
      services = args.drop(1)
      ParsedArguments.new(port, @options[:host], services)
    rescue OptionParser::InvalidOption => io
      raise ConfigurationError, io.message
    end

    def usage
      @option_parser.help
    end

    private

    def init_option_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: bane [options] port [behaviors]'
        opts.separator ''
        opts.on('-l', '--listen-on-localhost',
                "Listen on localhost, (#{default_host}). [default]") do
          @options[:host] = default_host
        end
        opts.on('-a', '--listen-on-all-hosts', "Listen on all interfaces, (#{all_interfaces})") do
          @options[:host] = all_interfaces
        end
        opts.separator ''
        opts.separator 'All behaviors:'
        opts.separator @service_maker.all_service_names.map { |title| " - #{title}" }.join("\n")
      end
    end

    def parse_port(port)
      Integer(port)
    rescue ArgumentError
      raise ConfigurationError, "Invalid port number: #{port}"
    end

    def all_interfaces
      Services::ALL_INTERFACES
    end

    def default_host
      Services::DEFAULT_HOST
    end
  end

  class ParsedArguments

    attr_reader :port, :host, :services

    def initialize(port, host, services)
      @host = host
      @port = port
      @services = services
    end

    def empty?
      false
    end

    def self.empty
      EmptyArguments.new
    end
  end

  class EmptyArguments
    def empty?
      true
    end
  end

end
