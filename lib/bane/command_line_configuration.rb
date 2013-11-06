require 'optparse'

module Bane
  class CommandLineConfiguration
    def initialize
      @services = ServiceMaker.new
      @options = {host: default_host()}
      @option_parser = init_option_parser
    end

    def parse(args)
      parse_options(args)

      return [] if (args.empty?)

      port = parse_port(args[0])
      behaviors = args.drop(1)
      host = @options[:host]
      create(behaviors, port, host)
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
        opts.separator @services.all_service_names.map { |title| " - #{title}" }.join("\n")
      end
    end

    def parse_options(args)
      @option_parser.parse!(args)
      rescue OptionParser::InvalidOption => io
        raise ConfigurationError, io.message
    end

    def parse_port(port)
      Integer(port)
      rescue ArgumentError
        raise ConfigurationError, "Invalid port number: #{port}"
    end

    def create(behaviors, port, host)
      if behaviors.any?
        @services.create(behaviors, port, host)
      else
        @services.create_all(port, host)
      end
      rescue UnknownServiceError => ube
        raise ConfigurationError, ube.message
    end

    def all_interfaces
      Services::ALL_INTERFACES
    end

    def default_host
      Services::DEFAULT_HOST
    end

  end

  class ConfigurationError < RuntimeError; end

end
