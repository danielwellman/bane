require 'socket'

module Bane
  module Services

    DEFAULT_HOST = '127.0.0.1'
    ALL_INTERFACES = '0.0.0.0'

    class NeverListen

      def initialize(port, host = Services::DEFAULT_HOST)
        @port = port
        @host = host
        self.stdlog= $stderr
      end

      def start
        @server = Socket.new(:INET, :STREAM)
        address = Socket.sockaddr_in(port, host)
        @server.bind(address) # Note that we never call listen

        log 'started'
      end

      def join
        sleep
      end

      def stop
        @server.close
        log 'stopped'
      end

      def stdlog=(logger)
        @logger = logger
      end

      def self.make(port, host)
        new(port, host)
      end

      private

      attr_reader :host, :port, :logger

      def log(message)
        logger.puts "[#{Time.new.ctime}] #{self.class.unqualified_name} #{host}:#{port} #{message}"
      end
    end

    EXPORTED = [NeverListen]

  end
end