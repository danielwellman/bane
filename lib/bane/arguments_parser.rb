require 'optparse'

module Bane
  class ArgumentsParser
    def initialize(makeable_names)
      @makeable_names = makeable_names
      @options = {host: default_host}
      @option_parser = init_option_parser
    end

    def parse(args)
      @option_parser.parse!(args)

      raise ConfigurationError, "Missing arguments" if args.empty?

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
        opts.separator @makeable_names.sort.map { |title| " - #{title}" }.join("\n")
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
      Services::LOCALHOST
    end
  end

  class ParsedArguments

    attr_reader :port, :host, :services

    def initialize(port, host, services)
      @host = host
      @port = port
      @services = services
    end

  end

end
