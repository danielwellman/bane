require 'optparse'

module Bane
  class CommandLineConfiguration
    def initialize
      @options = {host: BehaviorServer::DEFAULT_HOST}
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
          "Listen on localhost, (#{BehaviorServer::DEFAULT_HOST}). [default]") do
          @options[:host] = BehaviorServer::DEFAULT_HOST
        end
        opts.on('-a', '--listen-on-all-hosts', "Listen on all interfaces, (#{BehaviorServer::ALL_INTERFACES})") do
          @options[:host] = BehaviorServer::ALL_INTERFACES
        end
        opts.separator ''
        opts.separator 'All behaviors:'
        opts.separator ServiceRegistry.all_server_names.map { |title| " - #{title}" }.join("\n")

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
        ServiceRegistry.create(behaviors, port, host)
      else
        ServiceRegistry.create_all(port, host)
      end
      rescue UnknownBehaviorError => ube
        raise ConfigurationError, ube.message
    end

  end

  class ConfigurationError < RuntimeError; end

end
